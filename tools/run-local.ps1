$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if($root -ne 'E:\OpenLeague'){throw 'Unexpected project root'}
$serverPath=Join-Path $root 'target\debug\openleague-server.exe'
$clientPath=Join-Path $root 'target\debug\openleague-client.exe'
if(!(Test-Path -LiteralPath $serverPath) -or !(Test-Path -LiteralPath $clientPath)){throw 'Build OpenLeague first'}
$receiptPath=Join-Path $root 'logs\live_processes.json'
$receipt=@{}
if(Test-Path -LiteralPath $receiptPath){
    $previous=Get-Content -LiteralPath $receiptPath -Raw | ConvertFrom-Json
    if($previous.launcher){
        $ownedLauncher=Get-Process -Id $previous.launcher -ErrorAction SilentlyContinue
        if($ownedLauncher -and $ownedLauncher.Path -eq (Join-Path $root 'launcher\src-tauri\target\debug\openleague-launcher.exe')){$receipt.launcher=$previous.launcher}
    }
    foreach($ownedId in @($previous.server,$previous.client)){
        if(!$ownedId){continue}
        $ownedProcess=Get-Process -Id $ownedId -ErrorAction SilentlyContinue
        if($ownedProcess -and $ownedProcess.Path -in @($serverPath,$clientPath)){throw 'An OpenLeague match is already running'}
    }
}
$env:OPENLEAGUE_SERVER='127.0.0.1:5896'
if(!$env:WGPU_BACKEND){$env:WGPU_BACKEND='vulkan'}
if(!$env:OPENLEAGUE_CHAMPION){$env:OPENLEAGUE_CHAMPION='garen'}
$newServer=Start-Process -FilePath $serverPath -WorkingDirectory $root -WindowStyle Hidden -RedirectStandardOutput "$root\logs\server.out.log" -RedirectStandardError "$root\logs\server.err.log" -PassThru
$newClient=Start-Process -FilePath $clientPath -WorkingDirectory $root -RedirectStandardOutput "$root\logs\client.out.log" -RedirectStandardError "$root\logs\client.err.log" -PassThru
$receipt.server=$newServer.Id;$receipt.client=$newClient.Id;$receipt.port=5896
$receipt | ConvertTo-Json | Set-Content -LiteralPath $receiptPath -Encoding utf8
Write-Output "OpenLeague client: $($newClient.Id); server: $($newServer.Id)"
