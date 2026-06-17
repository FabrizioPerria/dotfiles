$tcServer = ""
$tcBase = "$tcServer/app/rest"
$token = ""
$headers = @{ Authorization = "Bearer $token"; Accept = "application/json" }

# $TC = "http://dkctc01"
# $auth = "your_token_here"  # or use "user:pass" with -Credential

function FP-Symbols() {
param(
    [ValidateSet("X64", "Ps5", "ounce", "scarlett", "X64epic", "x64gdk")]
    [string]$Platform = "X64",

    [ValidateSet("Release", "Debug", "GameRelease", "Retail", "all")]
    [string]$Config = "all",
    [int]$Days = 3
)
$since = (Get-Date).AddDays(-$Days).ToUniversalTime().ToString("yyyyMMddTHHmmss") + "%2B0000"
$configs = if ($Config -eq "All") { @("Release", "Debug", "GameRelease", "Retail") } else { @($Config) }
foreach ($cfg in $configs) {
    if ($Config -eq "All") { Write-Host "`n=== $Platform - $cfg ===" -ForegroundColor Cyan }

    $compileTypeId = "PrjKnt_PatchLaunch_$($Platform)$cfg"
    $symStoreTypeId = "PrjKnt_PatchLaunch_$($Platform)$($cfg)SymStore"
    $relBuilds = Invoke-RestMethod "$tcServer/app/rest/builds?locator=buildType:$compileTypeId,sinceDate:$since,count:100" -Headers $headers
    $results = foreach ($build in $relBuilds.build) {
        $buildId = $build.id

        $fullBuild = Invoke-RestMethod "$tcServer/app/rest/builds/id:$buildId" -Headers $headers
        if ($fullBuild.state -eq "running") { continue }
        $cl = $fullBuild.number
        $releaseDate = $fullBuild.startDate
        $releaseStatus = $fullBuild.status
        $symStore = Invoke-RestMethod "$tcServer/app/rest/builds?locator=buildType:$symStoreTypeId,snapshotDependency:(from:(id:$buildId)),count:1" -Headers $headers

        if ($symStore.count -eq 0) {
            $status = if ($releaseStatus -eq "FAILURE") { "FAILED (Compile)" } else { "SKIPPED/MISSING" }
            $status = if ($releaseStatus -eq "FAILURE") { "FAILED (Compile)" } 
              elseif ($fullBuild.customized) { "SKIPPED(CUSTOM)" }
              else { "SKIPPED/MISSING" }
            $symId = "-"
            $symDate = "-"
        } else {
            $fullSym = Invoke-RestMethod "$tcServer/app/rest/builds/id:$($symStore.build[0].id)" -Headers $headers
            # if ($fullSym.state -eq "running") { continue }
            $status = if ($fullSym.status -eq "SUCCESS") { "OK" } else { $fullSym.status }
            $symId = $fullSym.id
            $symDate = $fullSym.startDate
            $symStatus = $fullSim.state
        }
        $triggered = $fullBuild.triggered.type
        if ($fullBuild.triggered.buildType) {
            $triggered = "SnapshotDep: $($fullBuild.triggered.buildType.name)"
        }

        [PSCustomObject]@{
            CompileBuildId  = $buildId
            CL              = $cl
            CompileStarted  = $releaseDate
            SymStoreBuildId = $symId
            SymStoreStarted = $symDate
            SymStoreStatus  = $status
            SymStatus = $symStatus
            Triggered = $triggered
            CompileCustomized = if ($fullBuild.customized) { "CUSTOM" } else { "REGULAR" }
        }
    }
    $results | Where-Object { $_ -ne $null } | ForEach-Object {
        $_.CompileStarted = if ($_.CompileStarted -and $_.CompileStarted -ne "-") {
            [datetime]::ParseExact($_.CompileStarted.Substring(0,15), "yyyyMMddTHHmmss", $null).ToString("dd/MM/yyyy HH:mm")
        } else { "-" }
        $_.SymStoreStarted = if ($_.SymStoreStarted -and $_.SymStoreStarted -ne "-") {
            [datetime]::ParseExact($_.SymStoreStarted.Substring(0,15), "yyyyMMddTHHmmss", $null).ToString("dd/MM/yyyy HH:mm")
        } else { "-" }
        $_
    } | Format-Table -AutoSize
}
}

function FP-GetActiveAgents {
    $agents = Invoke-RestMethod "$tcBase/agents?locator=authorized:true&fields=agent(id,name,connected,enabled,build(id,buildTypeId,percentageComplete,running-info(elapsedSeconds,estimatedTotalSeconds,leftSeconds)))" -Headers $headers

    $agents.agent | ForEach-Object {
        $a = $_
        $status = "Idle"
        $sortKey = [double]::MinValue

        if ($a.build -and $a.build.'running-info') {
            $ri = $a.build.'running-info'
            $pct = $a.build.percentageComplete
            if ($ri.leftSeconds -le 0 -or $pct -ge 100) {
                $ot = [math]::Round(($ri.elapsedSeconds - $ri.estimatedTotalSeconds) / 60, 1)
                $status = "OVERTIME +${ot}m"
                $sortKey = $ri.elapsedSeconds - $ri.estimatedTotalSeconds
            } else {
                $status = "$([math]::Round($ri.leftSeconds / 60, 1))m left"
                $sortKey = -$ri.leftSeconds
            }
        }

        [PSCustomObject]@{
            Agent    = $a.name
            Status   = $status
            _sort    = $sortKey
            Url      = "$tcServer/agent/$($a.id)"
        }
    } | Where-Object { $_.Status -ne "Idle" } | Sort-Object _sort -Descending | ForEach-Object {
        $escLen = 12 + $_.Url.Length
        $pad = 20 + $escLen
        $link = "`e]8;;$($_.Url)`e\$($_.Agent)`e]8;;`e\"
        "{0,-$pad}  {1,-20}" -f $link, $_.Status
    }
}

function FP-GetRunningJobs {
    $builds = Invoke-RestMethod "$tcBase/builds?locator=running:true&fields=build(id,buildTypeId,webUrl,statusText,percentageComplete,running-info(elapsedSeconds,estimatedTotalSeconds,leftSeconds,currentStageText),agent(name))&count=100" -Headers $headers

    Write-Host ("{0,-70}  {1,-25}  {2,-12}  {3,-8}  {4,-8}  {5}" -f "BuildType", "Agent", "Step", "Elapsed", "Est", "Status")
    Write-Host ("{0,-70}  {1,-25}  {2,-12}  {3,-8}  {4,-8}  {5}" -f "---------", "-----", "----", "-------", "---", "------")

    $builds.build | ForEach-Object {
        $b = $_
        $ri = $b.'running-info'
        $elapsed = [math]::Round($ri.elapsedSeconds / 60, 1)
        $est     = [math]::Round($ri.estimatedTotalSeconds / 60, 1)
        $status  = if ($ri.leftSeconds -le 0 -or $b.percentageComplete -ge 100) {
            $ot = [math]::Round(($ri.elapsedSeconds - $ri.estimatedTotalSeconds) / 60, 1)
            "OVERTIME +${ot}m"
        } else {
            "$([math]::Round($ri.leftSeconds / 60, 1))m left"
        }
        [PSCustomObject]@{
            BuildType = $b.buildTypeId
            Agent     = $b.agent.name
            Step      = ($b.statusText -split ':')[0].Trim()
            Elapsed   = "${elapsed}m"
            Est       = "${est}m"
            Status    = $status
            _sort     = if ($ri.leftSeconds -le 0 -or $b.percentageComplete -ge 100) { $ri.elapsedSeconds - $ri.estimatedTotalSeconds } else { -$ri.leftSeconds }
            Url       = $b.webUrl
        }
    } | Sort-Object _sort -Descending | ForEach-Object {
        $escLen = 12 + $_.Url.Length
        $pad    = 70 + $escLen
        $link   = "`e]8;;$($_.Url)`e\$($_.BuildType)`e]8;;`e\"
        "{0,-$pad}  {1,-25}  {2,-12}  {3,-8}  {4,-8}  {5}" -f $link, $_.Agent, $_.Step, $_.Elapsed, $_.Est, $_.Status
    }

}

function FP-GetNewFails() {
    param(
        [int]$Days = 1
    )

    $tcServer = "https://dkctc01.corp.ioi.dk"
    $tcBase = "$tcServer/app/rest"
    $token = "eyJ0eXAiOiAiVENWMiJ9.VC05aElydnRXMGNGVXhfWFI5VW1jdFRTZUdr.ODliZTI5MzEtYmU1ZS00ZWU0LTg2YjUtMjJiYTY1ZWVhMThh"
    $headers = @{ Authorization = "Bearer $token"; Accept = "application/json" }

    $since = (Get-Date).Date.AddDays(-($Days - 1)).ToString("yyyyMMddTHHmmss") + "%2B0100"
    $fails = Invoke-RestMethod "$tcBase/builds?locator=failedToStart:any,status:FAILURE,sinceDate:$since&fields=build(id,buildTypeId,webUrl,statusText,finishDate,buildType(name,projectName))&count=500" -Headers $headers
    $newFails = $fails.build | Where-Object { $_.statusText -match '\(new\)' } | Sort-Object { $_.finishDate } -Descending

    $running = Invoke-RestMethod "$tcBase/builds?locator=running:true&fields=build(buildTypeId)&count=200" -Headers $headers
    $runningIds = @($running.build.buildTypeId)

# For each new fail, check if a successful build ran after it for the same buildTypeId
    $successSince = (Get-Date).Date.AddDays(-($Days - 1)).ToString("yyyyMMddTHHmmss") + "%2B0100"
    $successes = Invoke-RestMethod "$tcBase/builds?locator=status:SUCCESS,sinceDate:$successSince&fields=build(buildTypeId,finishDate)&count=500" -Headers $headers

# Build a lookup: buildTypeId -> latest success finishDate
    $latestSuccess = @{}
    $successes.build | ForEach-Object {
        $id = $_.buildTypeId
        if (-not $latestSuccess.ContainsKey($id) -or $_.finishDate -gt $latestSuccess[$id]) {
            $latestSuccess[$id] = $_.finishDate
        }
    }

    function Print-Fails($list) {
        $list | ForEach-Object {
            $time = [datetime]::ParseExact($_.finishDate, "yyyyMMddTHHmmsszzz", $null).ToString("MM/dd HH:mm")
            $escLen = 12 + $_.webUrl.Length
            $pad = 60 + $escLen
            $link = "`e]8;;$($_.webUrl)`e\$($_.buildType.name)`e]8;;`e\"
            "{0,-$pad}  {1,-12}  {2}" -f $link, $time, $_.buildType.projectName
        }
    }

    Write-Host "`n=== NEW FAILURES (last $Days day(s)) ===" -ForegroundColor Red
    Print-Fails $newFails

    Write-Host "`n=== NEW FAILURES WITH NO RUNNING FIX AND NO SUBSEQUENT SUCCESS ===" -ForegroundColor Yellow
    $unresolved = $newFails | Where-Object {
        $btId = $_.buildTypeId
        $failTime = $_.finishDate
        $hasRunning = $btId -in $runningIds
        $hasSuccess = $latestSuccess.ContainsKey($btId) -and $latestSuccess[$btId] -gt $failTime
        -not $hasRunning -and -not $hasSuccess
    }
    Print-Fails $unresolved

}

function Parse-BuildId([string]$name) {
    if ($name -match '-ID(\d+)-') { return $Matches[1] }
    throw "Could not parse build ID from: $name"
}

function Parse-CL([string]$name) {
    if ($name -match '-codeCL(\d+)-') { return [int]$Matches[1] }
    throw "Could not parse codeCL from: $name"
}
function FP-ListBuildsForCLRange() {
    param(
        [Parameter(Mandatory)][string] $GoodBuild,  # Base-PRJ_KNT-...-ID9831832-...
        [Parameter(Mandatory)][string] $BadBuild    # Base-PRJ_KNT-...-ID9833316-...
    )

    $ErrorActionPreference = 'Stop'

    $fromCL  = Parse-CL $GoodBuild
    $toCL    = Parse-CL $BadBuild
    $goodId  = Parse-BuildId $GoodBuild
    $badId   = Parse-BuildId $BadBuild

    Write-Host "CL range: $fromCL -> $toCL"
    Write-Host "Build ID range: $goodId -> $badId"
    Write-Host "Querying builds in that range...`n"

    # Fetch all finished builds between the two build IDs (all buildTypes)
    $buildsUrl = "$tcBase/builds?locator=sinceBuild:id:$goodId,untilBuild:id:$badId,state:finished&fields=build(id,number,buildTypeId,buildType(name,projectName),status,finishDate,webUrl)&count=500"
    $builds = Invoke-RestMethod $buildsUrl -Headers $headers

    if (-not $builds.build) {
        Write-Host "No builds found in range."
        return
    }

    Write-Host ("{0,-60}  {1,-30}  {2,-8}  {3}" -f "Build", "Project", "Status", "Finished")
    Write-Host ("{0,-60}  {1,-30}  {2,-8}  {3}" -f "-----", "-------", "------", "--------")

    $builds.build | Sort-Object finishDate | ForEach-Object {
        $b = $_
        $time = [datetime]::ParseExact($b.finishDate, "yyyyMMddTHHmmsszzz", $null).ToString("MM/dd HH:mm")
        $escLen = 12 + $b.webUrl.Length
        $pad = 60 + $escLen
        $link = "`e]8;;$($b.webUrl)`e\$($b.buildType.name)`e]8;;`e\"
        "{0,-$pad}  {1,-30}  {2,-8}  {3}" -f $link, $b.buildType.projectName, $b.status, $time
    }
}

function FP-JobsRanLastMonth() {
    param(
        [Parameter(Mandatory)][string] $ProjectId,
        [int] $Months = 1
    )

    $since = (Get-Date).AddMonths(-$Months).ToString("yyyy-MM-dd")

    # tc run list returns one row per build; --json emits an array.
    $json = teamcity run list `
        --project $ProjectId `
        --since   $since `
        --limit   100000 `
        --json    buildTypeId,buildType.name,buildType.projectName 2>$null

    $runs = ($json | ConvertFrom-Json).build
    if (-not $runs) { Write-Host "No runs found."; return }

    $jobs = $runs |
        Group-Object buildTypeId |
        ForEach-Object {
            $first = $_.Group[0]
            [PSCustomObject]@{
                ProjectName = $first.buildType.projectName
                Name        = $first.buildType.name
                ProjectId   = $_.Name
                Runs        = $_.Count
            }
        } |
        Sort-Object ProjectName, Name

    Write-Host "`n=== Jobs in '$ProjectId' that ran >=1 time in last $Months month(s) ===" -ForegroundColor Cyan
    Write-Host ("Found {0} distinct jobs`n" -f $jobs.Count)
    $jobs | ForEach-Object {
        "- [ ] {0} / {1} ({2})" -f $_.ProjectName, $_.Name, $_.ProjectId
    }
}

function FP-ProjectAgentPools() {
    <#
      Map subprojects under $RootProjectId to agent pools (teamcity CLI, not REST).

      Pool model: every project is in "Default"; assigning to another pool is additive.
      Subprojects inherit a non-Default pool from the nearest assigned ancestor. We report
      the effective NON-Default pool (direct or inherited), else Default.

      Switches:
        -ActiveOnly   keep only projects that DIRECTLY contain a job that ran in last $Months
        -OnlyAssigned hide Default-only rows
        -ByPool       group output BY POOL -> the projects to assign to each pool (UI view)

      Usage:
        FP-ProjectAgentPools -RootProjectId PRO_HMN
        FP-ProjectAgentPools -RootProjectId PRO_HMN -ActiveOnly
        FP-ProjectAgentPools -RootProjectId PRO_HMN -ActiveOnly -ByPool
        FP-ProjectAgentPools -RootProjectId PRO_HMN -ActiveOnly -ByPool -Months 2
    #>
    param(
        [Parameter(Mandatory)][string] $RootProjectId,
        [switch] $OnlyAssigned,
        [switch] $ActiveOnly,
        [switch] $ByPool,
        [int]    $Months = 1
    )

    # 1. all projects -> parent / name maps
    $all = (teamcity project list --limit 100000 --json=id,name,parentProjectId 2>$null | ConvertFrom-Json).project
    if (-not $all) { Write-Host "No projects returned (check 'teamcity auth')."; return }
    $parentOf = @{}; $nameOf = @{}
    foreach ($p in $all) { $parentOf[$p.id] = $p.parentProjectId; $nameOf[$p.id] = $p.name }

    function Is-Descendant([string]$id, [string]$root) {
        $c = $id; while ($c) { if ($c -eq $root) { return $true }; $c = $parentOf[$c] }; return $false
    }
    $projects = $all | Where-Object { Is-Descendant $_.id $RootProjectId }
    if (-not $projects) { Write-Host "No projects under '$RootProjectId'."; return }

    # 1b. active project set = projects directly containing a job that ran in last $Months
    $activeSet = $null
    if ($ActiveOnly) {
        $since = (Get-Date).AddMonths(-$Months).ToString("yyyy-MM-dd")
        $runs  = (teamcity run list --project $RootProjectId --since $since --limit 100000 --json=buildType.projectId 2>$null | ConvertFrom-Json).build
        $activeSet = [System.Collections.Generic.HashSet[string]]::new()
        foreach ($r in $runs) { if ($r.buildType.projectId) { [void]$activeSet.Add($r.buildType.projectId) } }
        Write-Host ("Active projects (>=1 job ran in last $Months mo): {0}" -f $activeSet.Count)
    }

    # 2. each pool -> assigned projectIds + agents
    $pools = (teamcity pool list --json=id,name 2>$null | ConvertFrom-Json).agentPool
    $specificPoolsOfProject = @{}
    $agentsOfPool           = @{}
    foreach ($pl in $pools) {
        $poolId = if ($null -ne $pl.id) { $pl.id } else { 0 }   # Default pool = id 0
        $view   = teamcity pool view $poolId --json 2>$null | ConvertFrom-Json
        $agentsOfPool[$pl.name] = (@($view.agents.agent.name) -join ", ")
        if ($pl.name -eq "Default") { continue }
        foreach ($pp in @($view.projects.project)) {
            if (-not $specificPoolsOfProject.ContainsKey($pp.id)) { $specificPoolsOfProject[$pp.id] = @() }
            $specificPoolsOfProject[$pp.id] += $pl.name
        }
    }

    # 3. resolve effective non-Default pool(s) per project
    function Resolve-Pools([string]$_pid) {
        $cur = $_pid
        while ($cur) {
            if ($specificPoolsOfProject.ContainsKey($cur)) {
                $src = if ($cur -eq $_pid) { "direct" } else { "inherited:$($nameOf[$cur])" }
                return [PSCustomObject]@{ Pools = $specificPoolsOfProject[$cur]; Source = $src }
            }
            $cur = $parentOf[$cur]
        }
        return [PSCustomObject]@{ Pools = @("Default"); Source = "(default)" }
    }

    $entries = foreach ($p in ($projects | Sort-Object name)) {
        if ($ActiveOnly -and -not $activeSet.Contains($p.id)) { continue }
        $r = Resolve-Pools $p.id
        if ($OnlyAssigned -and $r.Source -eq "(default)") { continue }
        [PSCustomObject]@{ Project = $p.name; ProjectId = $p.id; Pools = $r.Pools; Source = $r.Source }
    }

    # 4a. grouped BY POOL (what to assign where)
    if ($ByPool) {
        $poolMap = @{}
        foreach ($e in $entries) {
            foreach ($pool in $e.Pools) {
                if (-not $poolMap.ContainsKey($pool)) { $poolMap[$pool] = @() }
                $poolMap[$pool] += $e
            }
        }
        Write-Host "`n=== Projects to assign per pool (under '$RootProjectId') ===" -ForegroundColor Cyan
        foreach ($pool in ($poolMap.Keys | Sort-Object)) {
            Write-Host ("`n## {0}    [agents: {1}]" -f $pool, $agentsOfPool[$pool]) -ForegroundColor Green
            $poolMap[$pool] | Sort-Object Project | ForEach-Object {
                "  - {0,-45} {1,-12} {2}" -f $_.Project, $_.Source, $_.ProjectId
            }
        }
        return
    }

    # 4b. flat per-project table
    $rows = $entries | ForEach-Object {
        [PSCustomObject]@{
            Project    = $_.Project
            AgentPool  = ($_.Pools -join ", ")
            Assignment = $_.Source
            Agents     = (($_.Pools | ForEach-Object { $agentsOfPool[$_] } | Where-Object { $_ }) -join " | ")
            ProjectId  = $_.ProjectId
        }
    }
    Write-Host "`n=== Agent pool per subproject under '$RootProjectId' ===" -ForegroundColor Cyan
    Write-Host ("{0} projects`n" -f @($rows).Count)
    $rows | Format-Table Project, AgentPool, Assignment, ProjectId -AutoSize
}

$tcServer = "https://dkctc01.corp.ioi.dk"
$tcBase   = "$tcServer/app/rest"
$token    = "eyJ0eXAiOiAiVENWMiJ9.VC05aElydnRXMGNGVXhfWFI5VW1jdFRTZUdr.ODliZTI5MzEtYmU1ZS00ZWU0LTg2YjUtMjJiYTY1ZWVhMThh"
$headers  = @{ Authorization = "Bearer $token"; Accept = "application/json" }

# Param refs that are always valid (server-provided / context). Not flagged as broken.
$script:KnownParamPrefixes = @(
    "system.", "env.", "teamcity.", "dep.", "build.", "reverse.dep.",
    "vcsroot.", "agent."
)

# teamcity-cli based. Auth handled by the CLI itself: run `teamcity auth login` once.
# No $token / $headers / Invoke-RestMethod here.

# Param refs that are always valid (server-provided / context). Not flagged as broken.
$script:KnownParamPrefixes = @(
    "system.", "env.", "teamcity.", "dep.", "build.", "reverse.dep.",
    "vcsroot.", "agent."
)

# teamcity-cli based. Auth handled by the CLI itself: run `teamcity auth login` once.
# No $token / $headers / Invoke-RestMethod here.

# Param refs that are always valid (server-provided / context). Not flagged as broken.
$script:KnownParamPrefixes = @(
    "system.", "env.", "teamcity.", "dep.", "build.", "reverse.dep.",
    "vcsroot.", "agent."
)

# teamcity-cli based. Auth handled by the CLI itself: run `teamcity auth login` once.
# No $token / $headers / Invoke-RestMethod here.

# Param refs that are always valid (server-provided / context). Not flagged as broken.
$script:KnownParamPrefixes = @(
    "system.", "env.", "teamcity.", "dep.", "build.", "reverse.dep.",
    "vcsroot.", "agent."
)

# teamcity-cli based. Auth handled by the CLI itself: run `teamcity auth login` once.
# No $token / $headers / Invoke-RestMethod here.

# Param refs that are always valid (server-provided / context). Not flagged as broken.
$script:KnownParamPrefixes = @(
    "system.", "env.", "teamcity.", "dep.", "build.", "reverse.dep.",
    "vcsroot.", "agent."
)

function FP-ParamIssues() {
    <#
      Scan every build config under $RootProjectId for VALUE REQUIRED params:
      %refs% used anywhere in the config (build steps, features, dependencies, VCS,
      param values) that match NO defined parameter and no known prefix. TeamCity
      surfaces exactly these as "<value is required>" prompts at trigger time, so an
      undefined ref blocks/forces input on the build.

      This is the same set the UI shows. A typo like %install-packageConfig% when only
      'install-package-config' is defined is caught (name mismatch -> undefined ref).

      Data via teamcity-cli:
        teamcity job list  --project X --limit 100000 --json=... -> .buildType (already recursive)
        teamcity job param list <id>   --json                    -> .property  (defined names)
        teamcity api .../buildTypes/id:<id>?fields=$long          -> full config text (all refs)

      Ref regex restricted to [A-Za-z0-9_.-] to avoid matching PowerShell '%{ }' etc in scripts.

      Usage:
        FP-ParamIssues -RootProjectId PRO_HMN
    #>
    param(
        [Parameter(Mandatory)][string] $RootProjectId
    )

    # --project already recurses into subprojects. Default --limit is 30, so raise it.
    $jobs = (teamcity job list --project $RootProjectId --limit 100000 `
                --json=id,name,projectName,webUrl 2>$null | ConvertFrom-Json).buildType
    if (-not $jobs) { Write-Host "No build configs under '$RootProjectId' (check 'teamcity auth login')."; return }

    Write-Host "`n=== Parameter issues under '$RootProjectId' ($($jobs.Count) configs scanned) ===" -ForegroundColor Cyan

    $issues = foreach ($j in $jobs) {
        # Defined params (own + inherited). param list takes job-id positionally; bare --json.
        $params = (teamcity job param list $j.id --json 2>$null | ConvertFrom-Json).property
        $defined = [System.Collections.Generic.HashSet[string]]::new()
        foreach ($p in $params) { [void]$defined.Add($p.name) }

        # Full config text = every place a %ref% can live (steps, features, deps, VCS, values).
        $cfg = (teamcity api "/app/rest/buildTypes/id:$($j.id)?fields=`$long" 2>$null) -join "`n"
        if (-not $cfg) { continue }

        $seen = [System.Collections.Generic.HashSet[string]]::new()
        foreach ($m in [regex]::Matches($cfg, '%([A-Za-z0-9_.\-]+)%')) {
            $ref = $m.Groups[1].Value
            if ($script:KnownParamPrefixes | Where-Object { $ref.StartsWith($_) }) { continue }
            if ($defined.Contains($ref)) { continue }
            if (-not $seen.Add($ref)) { continue }            # dedupe per job
            [PSCustomObject]@{
                Config = $j.name; ProjectName = $j.projectName; WebUrl = $j.webUrl
                Param = $ref; Issue = "VALUE REQUIRED"; Detail = "undefined ref"
            }
        }
    }

    if (-not $issues) { Write-Host "No issues found." -ForegroundColor Green; return }

    Write-Host ("Found {0} issue(s)`n" -f @($issues).Count) -ForegroundColor Yellow
    $issues | Sort-Object ProjectName, Config | ForEach-Object {
        $url    = "$($_.WebUrl)/parameters"
        $escLen = 12 + $url.Length
        $pad    = 50 + $escLen
        $link   = "`e]8;;$url`e\$($_.Config)`e]8;;`e\"
        "{0,-$pad}  {1,-12}  {2,-30}  {3}" -f $link, $_.Issue, $_.Param, $_.Detail
    }
}

function FP-JobsNoAgent() {
    <#
      List build configs under $RootProjectId with ZERO compatible agents.

      teamcity job list --project X --limit 100000       -> .buildType (already recursive)
      teamcity api "/app/rest/agents?locator=compatible:(buildType:(id:<id>))&fields=count"
        -> { count } ; count:0 = nothing can run it.
      (compatibleAgents subresource returns 406 via CLI; agents locator used instead.)

      Paused configs flagged separately (PAUSED) since 0 agents may be expected there.

      CAVEAT: count is authorized agents matching requirements. 0 = no capable agent OR
      all matching agents removed. Disconnected-but-authorized still count.

      Usage:
        FP-JobsNoAgent -RootProjectId PRO_HMN
        FP-JobsNoAgent -RootProjectId PRO_HMN -IncludePaused
    #>
    param(
        [Parameter(Mandatory)][string] $RootProjectId,
        [switch] $IncludePaused
    )

    # --project already recurses into subprojects. Default --limit is 30, so raise it.
    $jobs = (teamcity job list --project $RootProjectId --limit 100000 `
                --json=id,name,projectName,webUrl,paused 2>$null | ConvertFrom-Json).buildType
    if (-not $jobs) { Write-Host "No build configs under '$RootProjectId' (check 'teamcity auth login')."; return }

    Write-Host "`n=== Build configs with NO compatible agent under '$RootProjectId' ($($jobs.Count) scanned) ===" -ForegroundColor Cyan

    $bad = foreach ($j in $jobs) {
        if ($j.paused -and -not $IncludePaused) { continue }
        # compatibleAgents subresource returns 406 via CLI; use the agents locator instead.
        $ca = teamcity api "/app/rest/agents?locator=compatible:(buildType:(id:$($j.id)))&fields=count" 2>$null | ConvertFrom-Json
        if ($ca.count -ne 0) { continue }
        [PSCustomObject]@{
            Config = $j.name; ProjectName = $j.projectName; WebUrl = $j.webUrl
            State  = if ($j.paused) { "PAUSED" } else { "ACTIVE" }
        }
    }

    if (-not $bad) { Write-Host "All configs have >=1 compatible agent." -ForegroundColor Green; return }

    Write-Host ("Found {0} config(s) with no compatible agent`n" -f @($bad).Count) -ForegroundColor Yellow
    $bad | Sort-Object ProjectName, Config | ForEach-Object {
        $url    = "$($_.WebUrl)/agents"
        $escLen = 12 + $url.Length
        $pad    = 50 + $escLen
        $link   = "`e]8;;$url`e\$($_.Config)`e]8;;`e\"
        "{0,-$pad}  {1,-8}  {2}" -f $link, $_.State, $_.ProjectName
    }
}

# FP-DumpJobConfigs.ps1
# Dump the EFFECTIVE (template-merged) config of every relevant job to JSON files,
# so tooling can diff generated-vs-original from static files instead of querying TC.
#
# Why effective: /app/rest/buildTypes/id:<id>?fields=steps(...) returns template steps
# merged in (each step carries inherited=true/false) + disabled flags + full script.content.
# That removes the manual template-merge / disabled-settings / param-resolution that the XML
# dump forces (and that caused wrong "matches original" calls).
#
# Auth: reuses your global $tcBase + $headers (defined in your profile, as FP-GetRunningJobs does).
# Listing: uses the `teamcity` CLI (recursive --project), like FP-JobsRanLastMonth.
#
# Usage:
#   FP-DumpJobConfigs -RootProjectId PRO_HMN                         # all jobs under PRO_HMN
#   FP-DumpJobConfigs -RootProjectId PRO_HMN -ActiveOnly -Months 2   # only jobs that ran in last 2mo
#   FP-DumpJobConfigs -RootProjectId PRO_HMN -ActiveOnly -Resolved   # + resolved param literals (last build)
#   FP-DumpJobConfigs -RootProjectId PRO_HMN -OutDir './tc_effective'
#
#   # Prod branches run rarely + sit paused — paused is NOT a proxy for dead. Use a long
#   # run window instead. This reproduces the 82-job del03 "actually ran" list:
#   FP-DumpJobConfigs -RootProjectId PRO_Hitman33230del03 -ActiveOnly -Months 12 -OutDir './del03/tc_effective'
#
# Output (one folder, drop it in the TC project folder for the assistant to read):
#   <OutDir>/_index.tsv                 jobId <tab> name <tab> projectName <tab> paused <tab> runs
#                                       (runs = builds in the window; '-' when -ActiveOnly not used)
#   <OutDir>/<jobId>.json               effective config (steps+script.content, params, reqs, deps, vcs, triggers, features, settings)
#   <OutDir>/<jobId>.resolved.json      (with -Resolved) actual resolved parameter values from the last finished build

function FP-DumpJobConfigs {
    param(
        [Parameter(Mandatory)][string] $RootProjectId,
        [string] $OutDir = "./tc_effective",
        [switch] $ActiveOnly,
        [int]    $Months = 2,
        [switch] $Resolved
    )

    if (-not $tcBase -or -not $headers) {
        Write-Host "ERROR: `$tcBase / `$headers not set. Load your TC profile first (the block that defines `$tcServer/`$tcBase/`$token/`$headers)." -ForegroundColor Red
        return
    }

    # Comprehensive field set: every place a difference can live. steps(...properties...) carries the
    # full script.content; inherited=true marks template-merged steps; disabled marks turned-off ones.
    $fields = @(
        'id,name,description,projectName,paused'
        'settings(property(name,value))'
        'parameters(property(name,value,inherited))'
        'steps(step(id,name,type,disabled,inherited,properties(property(name,value))))'
        'features(feature(id,type,disabled,inherited,properties(property(name,value))))'
        'triggers(trigger(id,type,disabled,inherited,properties(property(name,value))))'
        'vcs-root-entries(vcs-root-entry(id,checkout-rules,vcs-root(id,name)))'
        'snapshot-dependencies(snapshot-dependency(id,source-buildType(id,name),properties(property(name,value))))'
        'artifact-dependencies(artifact-dependency(id,disabled,source-buildType(id,name),properties(property(name,value))))'
        'agent-requirements(agent-requirement(id,type,disabled,properties(property(name,value))))'
    ) -join ','

    New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

    # 1. List jobs (teamcity CLI --project already recurses; default --limit is 30, so raise it).
    $jobs = (teamcity job list --project $RootProjectId --limit 100000 `
                --json=id,name,projectName,paused 2>$null | ConvertFrom-Json).buildType
    if (-not $jobs) { Write-Host "No jobs under '$RootProjectId' (check 'teamcity auth login')." -ForegroundColor Red; return }

    # 2. Optional active filter = jobs that ran >=1 time in last $Months. Also keeps a per-job
    #    run count so the index shows HOW active each job is (run-frequency = priority order).
    $runCount = @{}
    if ($ActiveOnly) {
        $since = (Get-Date).AddMonths(-$Months).ToString("yyyy-MM-dd")
        $runs  = (teamcity run list --project $RootProjectId --since $since --limit 100000 `
                    --json=buildTypeId 2>$null | ConvertFrom-Json).build
        foreach ($r in $runs) {
            if ($r.buildTypeId) { $runCount[$r.buildTypeId] = 1 + [int]$runCount[$r.buildTypeId] }
        }
        $jobs = $jobs | Where-Object { $runCount.ContainsKey($_.id) }
        Write-Host "Active filter: $($jobs.Count) job(s) ran in last $Months month(s) ($(@($runs).Count) total runs)." -ForegroundColor Cyan

        Write-Host "`n=== Jobs by run count (last $Months mo) ===" -ForegroundColor Cyan
        $jobs | Sort-Object { -$runCount[$_.id] } | ForEach-Object {
            "{0,6}  {1}" -f $runCount[$_.id], $_.id | Write-Host
        }
        Write-Host ""
    }

    Write-Host "Dumping $($jobs.Count) job config(s) to $OutDir ..." -ForegroundColor Cyan
    $index = New-Object System.Collections.Generic.List[string]
    $ok = 0; $fail = 0

    foreach ($j in ($jobs | Sort-Object id)) {
        $cfg = Invoke-RestMethod "$tcBase/buildTypes/id:$($j.id)?fields=$fields" -Headers $headers
        if (-not $cfg) { Write-Host "  SKIP (no cfg): $($j.id)" -ForegroundColor Yellow; $fail++; continue }
        ($cfg | ConvertTo-Json -Depth 40) | Out-File -FilePath (Join-Path $OutDir "$($j.id).json") -Encoding utf8

        if ($Resolved) {
            # Resolved parameter literals = actual values from the most recent finished build.
            $lb = Invoke-RestMethod "$tcBase/builds?locator=buildType:$($j.id),count:1,state:finished&fields=build(id)" -Headers $headers
            if ($lb.build) {
                $rp = Invoke-RestMethod "$tcBase/builds/id:$($lb.build[0].id)/resulting-properties/" -Headers $headers
                ($rp | ConvertTo-Json -Depth 10) | Out-File -FilePath (Join-Path $OutDir "$($j.id).resolved.json") -Encoding utf8
            }
        }

        $runs = if ($ActiveOnly) { [string]$runCount[$j.id] } else { "-" }
        $index.Add(("{0}`t{1}`t{2}`t{3}`t{4}" -f $j.id, $j.name, $j.projectName, $j.paused, $runs))
        $ok++
        Write-Host "  $($j.id)"
    }

    $index | Out-File -FilePath (Join-Path $OutDir "_index.tsv") -Encoding utf8
    Write-Host "`nDone. $ok config(s) written, $fail skipped. Folder: $OutDir" -ForegroundColor Green
    Write-Host "Drop '$OutDir' into the TC project folder; the assistant reads <jobId>.json (effective, template-merged)."
}
