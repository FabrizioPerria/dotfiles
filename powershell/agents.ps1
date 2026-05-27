function FP-agentsInfo () {
$agents = (Invoke-RestMethod -Uri 'https://psu.smog.ioi.dk/agentapi' -Method GET).name | Where-Object { $_ -like 'DKCBLD*' }

$poolMap = @{}
try {
    $poolsJson = teamcity api '/app/rest/agentPools?fields=agentPool(name,agents(agent(name)))' -H "Accept: application/json"
    $pools = $poolsJson | ConvertFrom-Json
    foreach ($pool in $pools.agentPool) {
        foreach ($agent in $pool.agents.agent) {
            # Normalize: strip -DESKTOP, -SERVICE, -D1, -S1, -M, -STEAM1, -<digit>, etc.
            $base = ($agent.name -replace '-.*$', '').ToUpper()
            # If a host has multiple TC agents, join the pool names
            if ($poolMap.ContainsKey($base)) {
                $poolMap[$base] = ($poolMap[$base], $pool.name) -join ', '
            } else {
                $poolMap[$base] = $pool.name
            }
        }
    }
} catch {
    Write-Warning "Could not fetch TeamCity agent pools: $_"
}

$opt = New-PSSessionOption -OperationTimeout 15000 -OpenTimeout 10000 -CancelTimeout 5000

$info = Invoke-Command -ComputerName $agents -Credential $cred -ThrottleLimit 120 -SessionOption $opt -ScriptBlock {
    $cpu  = Get-CimInstance Win32_Processor | Select-Object -First 1
    $os   = Get-CimInstance Win32_OperatingSystem
    $gpu  = (Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch 'Basic|Remote|Virtual' } | Select-Object -ExpandProperty Name) -join ', '
    $cDrv = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"
    $dDrv = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='D:'"
    $nics = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.Name -notmatch 'Loopback|isatap|teredo|bluetooth|pseudo|vEthernet|WSL|Hyper-V|VMware|VirtualBox|Docker|TAP' }

    function Get-DiskSummary($drive) {
        if (-not $drive) { return $null }
        $free = [math]::Round($drive.FreeSpace / 1GB, 1)
        $size = [math]::Round($drive.Size     / 1GB, 0)
        $used = [math]::Round(($drive.Size - $drive.FreeSpace) / $drive.Size * 100, 0)
        "$free / $size ($used% used)"
    }

    $diskC = Get-DiskSummary $cDrv
    $diskD = Get-DiskSummary $dDrv

    foreach ($nic in $nics) {
        [PSCustomObject]@{
            CPU                  = $cpu.Name.Trim()
            MemoryGB             = [math]::Round($os.TotalVisibleMemorySize / 1MB, 0)
            'Disk C'             = $diskC
            'Disk D'             = $diskD
            GPU                  = $gpu
            AdapterName          = $nic.Name
            # InterfaceDescription = $nic.InterfaceDescription
            LinkSpeed            = $nic.LinkSpeed
            MacAddress           = $nic.MacAddress
            # ifIndex              = $nic.ifIndex
        }
    }
} -ErrorAction SilentlyContinue -ErrorVariable failures

$info = $info | ForEach-Object {
    $_ | Add-Member -NotePropertyName 'TC Pool' -NotePropertyValue $poolMap[$_.PSComputerName.ToUpper()] -PassThru
}

$info | Sort-Object PSComputerName, AdapterName

# if ($failures) {
#     Write-Host "`nUnreachable hosts:" -ForegroundColor Yellow
#     $failures | ForEach-Object { $_.TargetObject }
# }
}
