$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if($root -ne 'E:\OpenLeague'){throw 'Unexpected project root'}
$receiptPath=Join-Path $root 'logs\live_processes.json'
if(!(Test-Path -LiteralPath $receiptPath)){return}
$receipt=Get-Content -LiteralPath $receiptPath -Raw | ConvertFrom-Json
foreach($ownedId in @($receipt.server,$receipt.client)){
    if(!$ownedId){continue}
    $ownedProcess=Get-Process -Id $ownedId -ErrorAction SilentlyContinue
    if($ownedProcess -and $ownedProcess.Path -in @("$root\target\debug\openleague-server.exe","$root\target\debug\openleague-client.exe")){Stop-Process -Id $ownedId}
}
Write-Output 'Owned OpenLeague match processes stopped.'
