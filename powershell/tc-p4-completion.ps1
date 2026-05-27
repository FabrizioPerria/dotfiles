# TeamCity + Perforce CLI completions for PowerShell
# Requires PSFzf with tab expansion enabled
# Dot-source from $PROFILE: . path\to\tc-p4-completion.ps1

#region Helpers

function _tcJobIds    { (teamcity.exe job list -n 9999 --json | ConvertFrom-Json).buildType | Select-Object -ExpandProperty id   -ErrorAction SilentlyContinue | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _tcProjectIds{ (teamcity.exe project list -n 9999 --json | ConvertFrom-Json).project  | Select-Object -ExpandProperty id   -ErrorAction SilentlyContinue | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _tcAgentNames{ (teamcity.exe agent list -n 9999 --json | ConvertFrom-Json).agent      | Select-Object -ExpandProperty name -ErrorAction SilentlyContinue | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _tcRunIds    { (teamcity.exe run list -n 9999 --json | ConvertFrom-Json).build        | Select-Object -ExpandProperty id   -ErrorAction SilentlyContinue | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _tcQueueIds  { (teamcity.exe queue list -n 9999 --json | ConvertFrom-Json).build      | Select-Object -ExpandProperty id   -ErrorAction SilentlyContinue | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _tcPoolNames { (teamcity.exe pool list --json | ConvertFrom-Json).pool                | Select-Object -ExpandProperty name -ErrorAction SilentlyContinue | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _gitBranches { git branch --format='%(refname:short)' 2>$null }

function _p4Changes   { p4 changes -s pending -m 9999 | ForEach-Object { ($_ -split '\s+')[1] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Clients   { p4 clients  | ForEach-Object { ($_ -split '\s+')[1] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Opened    { p4 opened   | ForEach-Object { ($_ -split '#')[0]   } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Branches  { p4 branches | ForEach-Object { ($_ -split '\s+')[2] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Labels    { p4 labels   | ForEach-Object { ($_ -split '\s+')[1] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Users     { p4 users    | ForEach-Object { ($_ -split '\s+')[0] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Groups    { p4 groups   | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4Jobs      { p4 jobs -m 9999 | ForEach-Object { ($_ -split '\s+')[0] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4FilesLocal { p4 have '...' 2>$null | ForEach-Object { ($_ -split ' - ')[-1] } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4FilesDepot { p4 have '...' 2>$null | ForEach-Object { ($_ -split '#')[0]       } | Where-Object { ![string]::IsNullOrEmpty($_) } }
function _p4FilesAdd   { Get-ChildItem -File | Select-Object -ExpandProperty Name }

function _complete($items, $word) {
    $items | Where-Object { ![string]::IsNullOrEmpty($_) } |
             Where-Object { $_ -like "$word*" } |
             ForEach-Object {
                 [System.Management.Automation.CompletionResult]::new(
                     [string]$_, [string]$_, 'ParameterValue', [string]$_)
             }
}

function _prevToken($tokens, $word) {
    if ($word -ne '' -and $tokens.Count -ge 2) { $tokens[-2] }
    elseif ($word -eq '' -and $tokens.Count -ge 1) { $tokens[-1] }
    else { '' }
}

#endregion

#region TeamCity

$_tcCompleter = {
    param($wordToComplete, $commandAst, $cursorPosition)

    $t    = $commandAst.CommandElements | ForEach-Object { $_.ToString() }
    $cmd  = if ($t.Count -ge 2) { $t[1] } else { '' }
    $sub  = if ($t.Count -ge 3) { $t[2] } else { '' }
    $prev = _prevToken $t $wordToComplete

    # Subcommands
    if ($cmd -eq '' -or ($t.Count -eq 2 -and $wordToComplete -ne '')) {
        return _complete @('agent','alias','api','auth','completion','help','job','pool','project','queue','run','skill') $wordToComplete
    }

    # Sub-subcommands
    if ($cmd -eq 'run'     -and ($sub -eq '' -or ($t.Count -eq 3 -and $wordToComplete -ne ''))) { return _complete @('artifacts','cancel','changes','comment','download','list','log','pin','restart','start','tag','tests','unpin','untag','view','watch') $wordToComplete }
    if ($cmd -eq 'job'     -and ($sub -eq '' -or ($t.Count -eq 3 -and $wordToComplete -ne ''))) { return _complete @('list','param','pause','resume','tree','view') $wordToComplete }
    if ($cmd -eq 'project' -and ($sub -eq '' -or ($t.Count -eq 3 -and $wordToComplete -ne ''))) { return _complete @('list','param','settings','token','tree','view') $wordToComplete }
    if ($cmd -eq 'agent'   -and ($sub -eq '' -or ($t.Count -eq 3 -and $wordToComplete -ne ''))) { return _complete @('authorize','deauthorize','disable','enable','exec','jobs','list','move','reboot','term','view') $wordToComplete }
    if ($cmd -eq 'queue'   -and ($sub -eq '' -or ($t.Count -eq 3 -and $wordToComplete -ne ''))) { return _complete @('approve','list','remove','top') $wordToComplete }
    if ($cmd -eq 'pool'    -and ($sub -eq '' -or ($t.Count -eq 3 -and $wordToComplete -ne ''))) { return _complete @('link','list','unlink','view') $wordToComplete }

    # Flag values
    switch ($prev) {
        '--project' { return _complete (_tcProjectIds) $wordToComplete }
        '--job'     { return _complete (_tcJobIds)     $wordToComplete }
        '-j'        { return _complete (_tcJobIds)     $wordToComplete }
        '--agent'   { return _complete (_tcAgentNames) $wordToComplete }
        '--pool'    { return _complete (_tcPoolNames)  $wordToComplete }
        '--branch'  { return _complete (_gitBranches)  $wordToComplete }
        '-b'        { return _complete (_gitBranches)  $wordToComplete }
        '--status'  { return _complete @('success','failure','running','error','unknown') $wordToComplete }
    }

    # Positional values
    switch ($cmd) {
        'run' { switch ($sub) {
            'start' { return _complete (_tcJobIds) $wordToComplete }
            { $_ -in 'cancel','restart','pin','unpin','tag','untag','view','log','watch','artifacts','download','changes','comment','tests' } { return _complete (_tcRunIds) $wordToComplete }
        }}
        'job'     { if ($sub -in @('view','pause','resume','tree','param')) { return _complete (_tcJobIds)     $wordToComplete } }
        'project' { if ($sub -in @('view','param','settings','token'))      { return _complete (_tcProjectIds) $wordToComplete } }
        'agent'   { if ($sub -in @('view','enable','disable','authorize','deauthorize','reboot','exec','term','jobs','move')) { return _complete (_tcAgentNames) $wordToComplete } }
        'queue'   { if ($sub -in @('approve','remove','top'))               { return _complete (_tcQueueIds)   $wordToComplete } }
        'pool'    { if ($sub -in @('view','link','unlink'))                 { return _complete (_tcPoolNames)  $wordToComplete } }
    }
}

Register-ArgumentCompleter -Native -CommandName 'tc'           -ScriptBlock $_tcCompleter
Register-ArgumentCompleter -Native -CommandName 'teamcity'     -ScriptBlock $_tcCompleter
Register-ArgumentCompleter -Native -CommandName 'teamcity.exe' -ScriptBlock $_tcCompleter

#endregion

#region Perforce

Register-ArgumentCompleter -Native -CommandName 'p4' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $t    = $commandAst.CommandElements | ForEach-Object { $_.ToString() }
    $cmd  = if ($t.Count -ge 2) { $t[1] } else { '' }
    $prev = _prevToken $t $wordToComplete

    # Subcommands
    if ($cmd -eq '' -or ($t.Count -eq 2 -and $wordToComplete -ne '')) {
        return _complete @(
            'add','annotate','branch','branches','change','changes','changelist','changelists',
            'clean','client','clients','copy','delete','describe','diff','diff2','dirs',
            'edit','filelog','files','fix','fixes','flush','fstat','grep','group','groups',
            'have','help','info','integrate','integrated','istat','job','jobs','label',
            'labels','labelsync','lock','login','logout','merge','move','opened','populate',
            'print','rec','reconcile','rename','reopen','reshelve','resolve','resolved',
            'revert','shelve','status','stream','streams','submit','switch','sync','tag',
            'undo','unlock','unshelve','update','user','users','where','workspace','workspaces'
        ) $wordToComplete
    }

    # Flag values
    switch ($prev) {
        '-c' {
            if ($cmd -in @('changes','changelists','clients','workspaces')) { return _complete (_p4Clients) $wordToComplete }
            else { return _complete (_p4Changes) $wordToComplete }
        }
        '-u' { return _complete (_p4Users) $wordToComplete }
    }

    # Positional values
    switch ($cmd) {
        { $_ -in 'describe','change','changelist','shelve','unshelve','submit','fix','reopen' } { return _complete (_p4Changes)    $wordToComplete }
        { $_ -in 'client','workspace' }                                                         { return _complete (_p4Clients)    $wordToComplete }
        'branch'                                                                                 { return _complete (_p4Branches)   $wordToComplete }
        { $_ -in 'label','labelsync','tag' }                                                    { return _complete (_p4Labels)     $wordToComplete }
        { $_ -in 'revert','resolve','lock','unlock','move','rename' }                           { return _complete (_p4Opened)     $wordToComplete }
        { $_ -in 'edit','delete','diff','annotate','filelog','fstat','print','grep' }           { return _complete (_p4FilesLocal) $wordToComplete }
        { $_ -in 'sync','flush','update' }                                                      { return _complete (_p4FilesDepot) $wordToComplete }
        { $_ -in 'add','rec','reconcile' }                                                      { return _complete (_p4FilesAdd)   $wordToComplete }
        'user'                                                                                   { return _complete (_p4Users)      $wordToComplete }
        'group'                                                                                  { return _complete (_p4Groups)     $wordToComplete }
        'job'                                                                                    { return _complete (_p4Jobs)       $wordToComplete }
    }
}

#endregion
