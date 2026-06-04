param(
    [string[]]$Paths = @()
)
$ErrorActionPreference = 'Stop'
$IMAGE     = 'devenv:latest'
$CONTAINER = 'devenv'

# Pick container engine: explicit override, else docker, else podman.
$ENGINE =
    if     ($env:CONTAINER_ENGINE)                              { $env:CONTAINER_ENGINE }
    elseif (Get-Command docker -ErrorAction SilentlyContinue)   { 'docker' }
    elseif (Get-Command podman -ErrorAction SilentlyContinue)   { 'podman' }
    else   { Write-Host "Neither docker nor podman is installed."; exit 1 }

# Rootless podman: map the host user to the container's dev (uid 1000) so bind
# mounts stay writable. keep-id is podman-only; rootful docker maps uid 1000
# directly, so it needs nothing here.
$engineArgs = @()
if ($ENGINE -eq 'podman') { $engineArgs += '--userns=keep-id:uid=1000,gid=1000' }

if (-not (& $ENGINE image inspect $IMAGE 2>$null)) {
    Write-Host "Image not found — run ./build.ps1 first."
    exit 1
}
if (& $ENGINE ps --format '{{.Names}}' | Select-String -Quiet "^$CONTAINER$") {
    Write-Host "Attaching to running container..."
    & $ENGINE exec -it $CONTAINER /bin/zsh -c "tmux -u new-session -A -s main"
    exit 0
}
if (& $ENGINE ps -a --format '{{.Names}}' | Select-String -Quiet "^$CONTAINER$") {
    & $ENGINE rm $CONTAINER
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
$mounts += '-v', "maven:/home/dev/.m2"
$mounts += '-v', "ssh:/home/dev/.ssh"
$mounts += '-v', "$PWSH_HOME/.zsh_history_devenv:/home/dev/.zsh_history"
$envFile = "$PWSH_HOME/.devenv.env"
$envArgs = @()
if (Test-Path $envFile) { $envArgs = '--env-file', $envFile }
& $ENGINE run -it --name $CONTAINER --hostname devenv --dns $env:DNS @engineArgs @envArgs @mounts $IMAGE
