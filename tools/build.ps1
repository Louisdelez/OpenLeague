$ErrorActionPreference='Stop'
$root=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
if($root -ne 'E:\OpenLeague'){throw 'Unexpected project root'}
$env:CARGO_HOME='C:\Users\loicd\.cargo'
$cargo='C:\Users\loicd\.cargo\bin\cargo.exe'
Push-Location $root
try {
    & $cargo fmt --all --check
    if($LASTEXITCODE -ne 0){throw 'Formatting failed'}
    & $cargo test -p openleague-core --offline
    if($LASTEXITCODE -ne 0){throw 'Core tests failed'}
    & $cargo test -p openleague-client --offline
    if($LASTEXITCODE -ne 0){throw 'Client tests failed'}
    & $cargo build --workspace --offline
    if($LASTEXITCODE -ne 0){throw 'Game build failed'}
    Push-Location (Join-Path $root 'launcher\src-tauri')
    try {
        & $cargo build --offline
        if($LASTEXITCODE -ne 0){throw 'Launcher build failed'}
    } finally {Pop-Location}
} finally {Pop-Location}
