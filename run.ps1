param(
    [string[]]$Paths = @()
)

$ErrorActionPreference = 'Stop'
$IMAGE     = 'devenv:latest'
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
    $abs  = (Resolve-Path $p -ErrorAction SilentlyContinue)?.Path ?? $p
    $name = Split-Path $abs -Leaf
    $mounts += '-v', "${abs}:/workspaces/${name}"
}

New-Item -ItemType Directory -Force -Path "$PWSH_HOME/.claude" | Out-Null
if (-not (Test-Path "$PWSH_HOME/.claude.json")) { New-Item "$PWSH_HOME/.claude.json" -ItemType File | Out-Null }

$mounts += '-v', "nvim-data:/home/dev/.local/share/nvim"
$mounts += '-v', "$PWSH_HOME/.claude:/home/dev/.claude"
$mounts += '-v', "$PWSH_HOME/.claude.json:/home/dev/.claude.json"

docker run -it --name $CONTAINER --hostname devenv @mounts $IMAGE

