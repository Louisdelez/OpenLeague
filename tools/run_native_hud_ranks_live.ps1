$ErrorActionPreference='Stop'
$runtimeRoot='E:\OpenLeague'
$backend=$args[0]
if ($backend -notin @('vulkan','dx12')) {throw 'Expected vulkan or dx12'}
$tag='native-hud-ranks-live-'+$backend+'-annie'
$prefix=Join-Path $runtimeRoot ('logs\'+$tag)
foreach ($suffix in @('-baseline.png','-purchased.png','-precast.png','-cast.png','-regenerated.png','-ready.png','-probe.json','-run.json')) {if (Test-Path -LiteralPath ($prefix+$suffix)) {throw 'Evidence prefix already exists'}}
if (Get-NetUDPEndpoint -LocalPort 5899 -ErrorAction SilentlyContinue) {throw 'Qualification port occupied'}
$env:OPENLEAGUE_CHAMPION='annie'
$env:OPENLEAGUE_SERVER='127.0.0.1:5899'
$env:WGPU_BACKEND=$backend
Remove-Item Env:OPENLEAGUE_SCREENSHOT -ErrorAction SilentlyContinue
Remove-Item Env:OPENLEAGUE_RENDER_LIFECYCLE -ErrorAction SilentlyContinue
$env:OPENLEAGUE_NATIVE_HUD_LIVE_PROBE=$prefix
$env:OPENLEAGUE_NATIVE_HUD_TRACE=$prefix+'-trace.json'
$env:OPENLEAGUE_NATIVE_HUD_BARS_TRACE=$prefix+'-bars-trace.json'
$env:OPENLEAGUE_NATIVE_HUD_PORTRAIT_TRACE=$prefix+'-portrait-trace.json'
$env:OPENLEAGUE_NATIVE_HUD_PANELS_TRACE=$prefix+'-panels-trace.json'
$env:OPENLEAGUE_NATIVE_HUD_SPELLS_TRACE=$prefix+'-spells-trace.json'
$env:OPENLEAGUE_NATIVE_HUD_RANKS_TRACE=$prefix+'-ranks-trace.json'
$serverProcess=$null
$clientProcess=$null
try {
 $serverProcess=Start-Process -FilePath (Join-Path $runtimeRoot 'target\debug\openleague-server.exe') -WorkingDirectory $runtimeRoot -WindowStyle Hidden -PassThru -RedirectStandardOutput ($prefix+'-server.stdout.log') -RedirectStandardError ($prefix+'-server.stderr.log')
 $deadline=[DateTime]::UtcNow.AddSeconds(10)
 do {
  if ($serverProcess.HasExited) {throw 'Owned server exited'}
  $endpoint=Get-NetUDPEndpoint -LocalPort 5899 -ErrorAction SilentlyContinue
  if ($endpoint -and $endpoint.OwningProcess -eq $serverProcess.Id) {break}
  Start-Sleep -Milliseconds 200
 } while ([DateTime]::UtcNow -lt $deadline)
 if (-not $endpoint -or $endpoint.OwningProcess -ne $serverProcess.Id) {throw 'Owned server endpoint not confirmed'}
 $clientProcess=Start-Process -FilePath (Join-Path $runtimeRoot 'target\debug\openleague-client.exe') -WorkingDirectory $runtimeRoot -WindowStyle Normal -PassThru -RedirectStandardOutput ($prefix+'-client.stdout.log') -RedirectStandardError ($prefix+'-client.stderr.log')
 $deadline=[DateTime]::UtcNow.AddSeconds(150)
 $passed=$false
 while ([DateTime]::UtcNow -lt $deadline) {
  if ($clientProcess.HasExited) {throw 'Owned client exited'}
  if (Test-Path -LiteralPath ($prefix+'-probe.json')) {
   try {$probe=Get-Content -Raw -LiteralPath ($prefix+'-probe.json') | ConvertFrom-Json} catch {$probe=$null}
   if ($probe -and $probe.error) {throw ('Live probe failed: '+$probe.error)}
   if ($probe -and $probe.passed) {$passed=$true;break}
  }
  Start-Sleep -Milliseconds 300
 }
 if (-not $passed) {throw 'Live probe observation deadline exceeded'}
 $captures=@($probe.records | Where-Object {$_.kind -eq 'capture_requested'})
 if ($captures.Count -ne 6) {throw 'Six actual capture phases required'}
 $names=@($captures | ForEach-Object {$_.label})
 if (($names -join ',') -ne 'baseline,purchased,precast,cast,regenerated,ready') {throw 'Unexpected capture phase ordering'}
 $captureHashes=@{}
 foreach ($capture in $captures) {if (-not (Test-Path -LiteralPath $capture.path)) {throw 'Actual framebuffer file missing'};$captureHashes[$capture.label]=(Get-FileHash -LiteralPath $capture.path -Algorithm SHA256).Hash.ToLower()}
 if ($captures[1].player.max_mana -le $captures[0].player.max_mana) {throw 'Authoritative purchase capacity not increased'}
 if ($captures[3].player.mana -ge $captures[2].player.mana) {throw 'Authoritative cast cost not observed'}
 if ([Math]::Floor($captures[4].player.mana) -lt [Math]::Floor($captures[3].player.mana)+5) {throw 'Authoritative regeneration increase not observed'}
 [pscustomobject]@{backend=$backend;champion='annie';passed=$true;complete=$false;client_pid=$clientProcess.Id;server_pid=$serverProcess.Id;client_sha256=(Get-FileHash -LiteralPath (Join-Path $runtimeRoot 'target\debug\openleague-client.exe') -Algorithm SHA256).Hash.ToLower();server_sha256=(Get-FileHash -LiteralPath (Join-Path $runtimeRoot 'target\debug\openleague-server.exe') -Algorithm SHA256).Hash.ToLower();capture_sha256=$captureHashes;probe=$probe;visual_inspection_pending=$true} | ConvertTo-Json -Depth 32 | Set-Content -LiteralPath ($prefix+'-run.json') -Encoding utf8
 Write-Output ('Live HUD purchase/cast/regeneration captured on '+$backend)
} finally {
 foreach ($owned in @($clientProcess,$serverProcess)) {if ($owned -and -not $owned.HasExited) {Stop-Process -Id $owned.Id -Force}}
}



