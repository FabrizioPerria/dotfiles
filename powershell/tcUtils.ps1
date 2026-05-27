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
