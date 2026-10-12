$ErrorActionPreference='Stop'
$root='E:\OpenLeague'
$cargo='C:\Users\loicd\.cargo\bin\cargo.exe'
Set-Location -LiteralPath $root
if(Get-Process cargo,rustc,openleague_core*,openleague_client*,openleague-client -ErrorAction SilentlyContinue){throw 'Build, tests or client active'}
& $cargo test -p openleague-core --lib -j 1 -- audio_ native_clock --test-threads=1 *> (Join-Path $root 'logs\core-loading-resource-manager-tests.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\core-loading-resource-manager-tests.log') -Tail 18
if($result -ne 0){throw 'Resource manager core qualification failed'}
Write-Output 'Building client with qualified resource manager core'
& $cargo build -p openleague-client --bin openleague-client -j 1 *> (Join-Path $root 'logs\client-loading-resource-manager-build.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\client-loading-resource-manager-build.log') -Tail 8
if($result -ne 0){throw 'Resource manager client build failed'}
& (Join-Path $root 'tools\run_loading_resource_manager_probes.ps1')
