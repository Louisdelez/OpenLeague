$ErrorActionPreference = 'Stop'
$runtimeRoot = 'E:\OpenLeague'
$captureBackend = $args[0]
if ($captureBackend -notin @('vulkan','dx12')) { throw 'Expected vulkan or dx12' }
$captureChampion = if ($args.Count -gt 1) { $args[1] } else { 'garen' }
if ($captureChampion -notin @('garen','ahri')) { throw 'Expected verified capture champion garen or ahri' }
$env:OPENLEAGUE_CHAMPION = $captureChampion
$captureTag = 'native-hud-bars-' + $captureBackend + '-' + $captureChampion
$capturePath = Join-Path $runtimeRoot ('logs\' + $captureTag + '.png')
if (Test-Path -LiteralPath $capturePath) { throw 'Capture exists; preserve earlier evidence' }
if (Get-NetUDPEndpoint -LocalPort 5899 -ErrorAction SilentlyContinue) { throw 'Qualification port already occupied' }
$env:OPENLEAGUE_SERVER = '127.0.0.1:5899'
$env:WGPU_BACKEND = $captureBackend
$env:OPENLEAGUE_SCREENSHOT = $capturePath
$env:OPENLEAGUE_SCREENSHOT_DELAY = '25'
$env:OPENLEAGUE_NATIVE_HUD_TRACE = Join-Path $runtimeRoot ('logs\' + $captureTag + '-trace.json')
$env:OPENLEAGUE_NATIVE_HUD_PANELS_TRACE = Join-Path $runtimeRoot ('logs\' + $captureTag + '-panels-trace.json')
$env:OPENLEAGUE_NATIVE_HUD_PORTRAIT_TRACE = Join-Path $runtimeRoot ('logs\' + $captureTag + '-portrait-trace.json')
$env:OPENLEAGUE_NATIVE_HUD_BARS_TRACE = Join-Path $runtimeRoot ('logs\' + $captureTag + '-bars-trace.json')
$serverProcess = $null
$clientProcess = $null
try {
    $serverProcess = Start-Process -FilePath (Join-Path $runtimeRoot 'target\debug\openleague-server.exe') -WorkingDirectory $runtimeRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $runtimeRoot ('logs\' + $captureTag + '-server.stdout.log')) -RedirectStandardError (Join-Path $runtimeRoot ('logs\' + $captureTag + '-server.stderr.log'))
    $serverDeadline = [DateTime]::UtcNow.AddSeconds(10)
    do {
        if ($serverProcess.HasExited) { throw 'Qualification server exited' }
        $endpoint = Get-NetUDPEndpoint -LocalPort 5899 -ErrorAction SilentlyContinue
        if ($endpoint -and $endpoint.OwningProcess -eq $serverProcess.Id) { break }
        Start-Sleep -Milliseconds 200
    } while ([DateTime]::UtcNow -lt $serverDeadline)
    if (-not $endpoint -or $endpoint.OwningProcess -ne $serverProcess.Id) { throw 'Own server endpoint not confirmed' }
    $clientProcess = Start-Process -FilePath (Join-Path $runtimeRoot 'target\debug\openleague-client.exe') -WorkingDirectory $runtimeRoot -WindowStyle Normal -PassThru -RedirectStandardOutput (Join-Path $runtimeRoot ('logs\' + $captureTag + '-client.stdout.log')) -RedirectStandardError (Join-Path $runtimeRoot ('logs\' + $captureTag + '-client.stderr.log'))
    $captureDeadline = [DateTime]::UtcNow.AddSeconds(100)
    while ([DateTime]::UtcNow -lt $captureDeadline -and -not (Test-Path -LiteralPath $capturePath)) {
        if ($clientProcess.HasExited) { throw 'Qualification client exited before capture' }
        Start-Sleep -Milliseconds 300
    }
    if (-not (Test-Path -LiteralPath $capturePath)) { throw 'Capture deadline exceeded' }
    Start-Sleep -Milliseconds 1500
    $trace = Get-Content -Raw -LiteralPath $env:OPENLEAGUE_NATIVE_HUD_TRACE | ConvertFrom-Json
    if ($trace.glyph_entities -lt 3 -or $trace.values.GoldStat -eq $null -or $trace.values.LevelStat -eq $null -or $trace.values.GameTime -eq $null) { throw 'Native HUD widget trace missing' }
    $panelTrace = Get-Content -Raw -LiteralPath $env:OPENLEAGUE_NATIVE_HUD_PANELS_TRACE | ConvertFrom-Json
    if ($panelTrace.entities -ne 3 -or $panelTrace.materials -ne 3) { throw 'Native frame trace incomplete' }
    $portraitTrace = Get-Content -Raw -LiteralPath $env:OPENLEAGUE_NATIVE_HUD_PORTRAIT_TRACE | ConvertFrom-Json
    if ($portraitTrace.loaded_base_portraits -ne 122 -or $portraitTrace.champion -ne $captureChampion) { throw 'Native portrait trace incomplete' }
    $barsTrace = Get-Content -Raw -LiteralPath $env:OPENLEAGUE_NATIVE_HUD_BARS_TRACE | ConvertFrom-Json
    if ($barsTrace.health_fraction -ne 1 -or $barsTrace.entities -lt 7) { throw 'Native HUD bars trace incomplete' }
    if ($captureChampion -eq 'ahri' -and $barsTrace.resource_fraction -ne 1) { throw 'Ahri authoritative mana bar missing' }
    if ($captureChampion -eq 'garen' -and $barsTrace.resource_kind -ne 'None') { throw 'Unexpected Garen resource kind' }
    [pscustomobject]@{ bars=$barsTrace; portrait=$portraitTrace; panels=$panelTrace; backend=$captureBackend; passed=$true; complete=$false; client_pid=$clientProcess.Id; server_pid=$serverProcess.Id; capture=$capturePath; capture_sha256=(Get-FileHash -LiteralPath $capturePath -Algorithm SHA256).Hash.ToLower(); client_sha256=(Get-FileHash -LiteralPath (Join-Path $runtimeRoot 'target\debug\openleague-client.exe') -Algorithm SHA256).Hash.ToLower(); server_sha256=(Get-FileHash -LiteralPath (Join-Path $runtimeRoot 'target\debug\openleague-server.exe') -Algorithm SHA256).Hash.ToLower(); trace=$trace; observation='Actual primary window framebuffer captured; visual inspection required' } | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath (Join-Path $runtimeRoot ('logs\' + $captureTag + '-run.json')) -Encoding utf8
    Write-Output ('Captured ' + $captureBackend + ' native HUD widgets: ' + $capturePath)
} finally {
    foreach ($ownedProcess in @($clientProcess,$serverProcess)) { if ($ownedProcess -and -not $ownedProcess.HasExited) { Stop-Process -Id $ownedProcess.Id -Force } }
}

