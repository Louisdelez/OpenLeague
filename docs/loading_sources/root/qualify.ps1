$ErrorActionPreference='Stop'
if(Get-Process cargo,rustc,openleague_core*,openleague_client*,openleague-client -ErrorAction SilentlyContinue){throw 'Build, tests or client active'}
$root='E:\OpenLeague'
Copy-Item -LiteralPath 'E:\mapslol3v3\loading_metadata_stage\run_loading_probes.ps1' -Destination (Join-Path $root 'tools\run_loading_probes.ps1')
Set-Location -LiteralPath $root
& 'C:\Users\loicd\.cargo\bin\cargo.exe' test -p openleague-client --bin openleague-client -j 1 -- native_replay native_filesystem_provider --test-threads=1 *> 'E:\OpenLeague\logs\client-loading-tests.log'
if($LASTEXITCODE -ne 0){Get-Content -LiteralPath 'E:\OpenLeague\logs\client-loading-tests.log' -Tail 35;throw 'client tests failed'}
Get-Content -LiteralPath 'E:\OpenLeague\logs\client-loading-tests.log' -Tail 9
& 'C:\Users\loicd\.cargo\bin\cargo.exe' build -p openleague-client --bin openleague-client -j 1 *> 'E:\OpenLeague\logs\client-loading-build.log'
if($LASTEXITCODE -ne 0){Get-Content -LiteralPath 'E:\OpenLeague\logs\client-loading-build.log' -Tail 35;throw 'client build failed'}
Get-Content -LiteralPath 'E:\OpenLeague\logs\client-loading-build.log' -Tail 3
& 'E:\OpenLeague\tools\run_loading_probes.ps1'
if($LASTEXITCODE -ne 0){throw 'client commands failed'}
