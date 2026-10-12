$ErrorActionPreference='Stop'
$root='E:\OpenLeague'
$stage='E:\mapslol3v3\loading_clock_integration'
$cargo='C:\Users\loicd\.cargo\bin\cargo.exe'
$python='C:\Users\loicd\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe'
Set-Location -LiteralPath $root
if(Get-Process cargo,rustc,openleague_core*,openleague_client*,openleague-client -ErrorAction SilentlyContinue){throw 'Build, tests or client active'}
Write-Output 'Starting core qualification'
& $cargo test -p openleague-core --lib -j 1 -- audio_ native_clock --test-threads=1 *> (Join-Path $root 'logs\core-process-clock-tests.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\core-process-clock-tests.log') -Tail 12
if($result -ne 0){throw 'Core process clock qualification failed'}
Write-Output 'Starting client qualification'
& $cargo test -p openleague-client --bin openleague-client -j 1 -- native_replay native_filesystem_provider native_effect_clock native_pause_freezes_ready --test-threads=1 *> (Join-Path $root 'logs\client-process-clock-tests.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\client-process-clock-tests.log') -Tail 22
if($result -ne 0){throw 'Client process clock qualification failed'}
Write-Output 'Building final client'
& $cargo build -p openleague-client --bin openleague-client -j 1 *> (Join-Path $root 'logs\client-process-clock-build.log')
$result=$LASTEXITCODE
Get-Content -LiteralPath (Join-Path $root 'logs\client-process-clock-build.log') -Tail 8
if($result -ne 0){throw 'Client process clock build failed'}
Write-Output 'Running final executable probes'
& (Join-Path $root 'tools\run_process_clock_probes.ps1')
if($LASTEXITCODE -ne 0){throw 'Final executable probes failed'}
Write-Output 'Recording verified evidence'
& $python (Join-Path $stage 'record_validation.py')
if($LASTEXITCODE -ne 0){throw 'Process clock evidence verification failed'}
