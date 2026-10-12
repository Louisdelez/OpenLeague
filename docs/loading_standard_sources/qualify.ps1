$ErrorActionPreference='Stop'
$root='E:\OpenLeague'
$stage='E:\mapslol3v3\loading_standard_integration'
$cargo='C:\Users\loicd\.cargo\bin\cargo.exe'
Set-Location -LiteralPath $root
if(Get-Process cargo,rustc,openleague_core*,openleague_client*,openleague-client -ErrorAction SilentlyContinue){throw 'Build, tests or client active'}
& $cargo test -p openleague-core --lib -j 1 -- audio_ native_clock --test-threads=1 *> (Join-Path $root 'logs\core-loading-standard-tests.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\core-loading-standard-tests.log') -Tail 16
if($result -ne 0){throw 'Loading standard core qualification failed'}
Write-Output 'Building client with qualified loading standard core'
& $cargo build -p openleague-client --bin openleague-client -j 1 *> (Join-Path $root 'logs\client-loading-standard-build.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\client-loading-standard-build.log') -Tail 8
if($result -ne 0){throw 'Loading standard client build failed'}
& (Join-Path $root 'tools\run_loading_standard_probes.ps1')
