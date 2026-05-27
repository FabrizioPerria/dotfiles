# Import modules
Import-Module posh-p4
Import-Module posh-git

$PWSH_HOME = "C:\Users\fabriziop\Documents\PowerShell"

function prompt
{
    $realLASTEXITCODE = $LASTEXITCODE
    
    # Capture current output position to detect if P4 wrote anything
    $beforePos = $host.UI.RawUI.CursorPosition
    Write-P4Prompt
    $afterPos = $host.UI.RawUI.CursorPosition
    
    # If P4 didn't write anything (cursor didn't move)
    if ($beforePos.X -eq $afterPos.X -and $beforePos.Y -eq $afterPos.Y)
    {
        # Show path
        Write-Host($pwd.ProviderPath) -NoNewline
        
        # Check for Git repo
        if (Get-GitDirectory)
        {
            $global:GitPromptSettings.BeforeStatus = " ["
            $global:GitPromptSettings.AfterStatus = "] > "
            $global:GitPromptSettings.PathStatusSeparator = ""
            Write-VcsStatus
        }
    }
    else
    {
        $cls = p4.exe changes -s pending -u $env:P4USER -m 5 2>$null
        if ($cls) {
            $numbers = ($cls | Select-String '\d+' | ForEach-Object { $_.Matches[0].Value }) -join ","
            Write-Host " [CL:$numbers]" -NoNewline -ForegroundColor Yellow
        }
    }
    
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " > "
}

#function p4 {
#    switch ($args[0]) {
#        "diff"     { cmd /c "p4 $args" }
#        "change"   { cmd /c "p4 $args" }
#        default    { & p4.exe $args }
#    }
#}

function crlf-to-lf {
    param(
        [string] $Path
    )

    $content = [System.IO.File]::ReadAllText("$Path") -replace "`r`n", "`n"
    [System.IO.File]::WriteAllText("$Path", $content, [System.Text.UTF8Encoding]::new($false))
}

function Get-UnixShell {
    param(
        [string[]]$Paths = @()
    )

    $ErrorActionPreference = 'Stop'
    $IMAGE     = 'devenv:latest'
    $CONTAINER = 'devenv'

    if (-not (docker image inspect $IMAGE 2>$null)) {
        Write-Host "Image not found — run ./build.ps1 first."
        exit 1
    }

    if (docker ps --format '{{.Names}}' | Select-String -Quiet "^$CONTAINER$") {
        Write-Host "Attaching to running container..."
        docker exec -it $CONTAINER /bin/zsh -c "tmux -u new-session -A -s main"
        exit 0
    }

    if (docker ps -a --format '{{.Names}}' | Select-String -Quiet "^$CONTAINER$") {
        docker rm $CONTAINER
    }

    $mounts = @()
    foreach ($p in $Paths) {
        $abs  = (Resolve-Path $p -ErrorAction SilentlyContinue)?.Path ?? $p
        $name = Split-Path $abs -Leaf
        $mounts += '-v', "${abs}:/workspaces/${name}"
    }

    New-Item -ItemType Directory -Force -Path "$PWSH_HOME/.claude" | Out-Null
    if (-not (Test-Path "$PWSH_HOME/.claude.json")) { New-Item "$PWSH_HOME/.claude.json" -ItemType File | Out-Null }

    $mounts += '-v', "nvim-data:/home/dev/.local/share/nvim"
    $mounts += '-v', "local-p4:/workspaces/linuxp4"

    $mounts += '-v', "claude-data:/home/dev/.claude"
    $mounts += '-v', "$PWSH_HOME/.claude.json:/home/dev/.claude.json"

    $envFile = "$PWSH_HOME/.devenv.env"
    $envArgs = @()
    if (Test-Path $envFile) {
        crlf-to-lf $envFile
        $envArgs = '--env-file', $envFile
    }

    docker run -it --name $CONTAINER --hostname devenv @envArgs --dns $env:DNS @mounts $IMAGE
}

function sh() {
    Get-UnixShell -Paths D:\scripting,D:\claude
}

function rc() {
    param(
        [string]$Source,
        [string]$Dest
    )

    robocopy $Source $Dest /E /MT:32 /J /R:2 /W:5 /NP /NDL /NFL
}

# $env:FZF_DEFAULT_COMMAND = 'fd --type f --strip-cwd-prefix'
$env:FZF_CTRL_T_COMMAND = 'fd --type f --strip-cwd-prefix'

Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r' -TabExpansion -TabCompletionPreviewWindow 'right|down|hidden' -EnableFd

$cred=Import-Clixml C:\Users\fabriziop\Documents\PowerShell\p.cred

. "$PWSH_HOME/p4ui.ps1"
. "$PWSH_HOME/tcUtils.ps1"
. "$PWSH_HOME/psUtils.ps1"
. "$PWSH_HOME/Whitelisting.ps1"
. "$PWSH_HOME/tc-p4-completion.ps1"
. "$PWSH_HOME/agents.ps1"

$env:TEAMCITY_TOKEN=""
$env:TEAMCITY_URL=""
$env:P4URL=""
$env:P4DOCKERCLIENT=""
$env:DNS=""

teamcity completion powershell | Out-String | Invoke-Expression
