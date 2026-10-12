$ErrorActionPreference='Stop'
$root='E:\OpenLeague'
$executable=Join-Path $root 'target\debug\openleague-client.exe'
if (Get-Process cargo,rustc,openleague_core*,openleague_client*,openleague-client -ErrorAction SilentlyContinue) { throw 'Build, tests or client active' }
$before=(Get-FileHash -LiteralPath $executable -Algorithm SHA256).Hash.ToLowerInvariant()
$runs=@(
 @('clock','--native-process-clock-probe'),
 @('events','--native-replay-events-probe'),
 @('probe','--native-replay-game-manager-probe'),
 @('stream-regression','--native-replay-recording-stream-probe'),
 @('file-regression','--native-replay-recording-file-probe'),
 @('running-regression','--native-replay-stream-running-probe'),
 @('opening-regression','--native-replay-stream-opening-probe'),
 @('transport-regression','--native-replay-stream-transport-probe'),
 @('base-regression','--native-replay-configuration-probe'),
 @('runtime-regression','--native-replay-runtime-probe'),
 @('service-regression','--native-replay-service-probe')
)
$reports=@()
foreach($run in $runs){
 $output=Join-Path $root ('logs\client-process-clock-'+$run[0]+'.json')
 $errorLog=Join-Path $root ('logs\client-process-clock-'+$run[0]+'.stderr.log')
 $process=Start-Process -FilePath $executable -ArgumentList @($run[1],$root) -WorkingDirectory $root -WindowStyle Hidden -RedirectStandardOutput $output -RedirectStandardError $errorLog -Wait -PassThru
 if($process.ExitCode -ne 0){Get-Content -LiteralPath $errorLog -Tail 20;throw "Probe failed: $($run[1]) / $($process.ExitCode)"}
 $parsed=Get-Content -LiteralPath $output -Raw -Encoding utf8 | ConvertFrom-Json
 if($null -eq $parsed){throw 'Missing JSON report'}
 $after=(Get-FileHash -LiteralPath $executable -Algorithm SHA256).Hash.ToLowerInvariant()
 if($after -ne $before){throw 'Client changed during probes'}
 $reports+=@{command=$run[1];root=$root;exit_code=$process.ExitCode;sha256=$after;output=$output;stderr=$errorLog}
 Write-Output "PASS $($run[1])"
}
@{executable=$executable;sha256=$before;commands=$reports}|ConvertTo-Json -Depth 6|Set-Content -LiteralPath (Join-Path $root 'logs\client-process-clock-command-run.json') -Encoding utf8
