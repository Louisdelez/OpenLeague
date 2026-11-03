[CmdletBinding()]
param([Parameter(ValueFromRemainingArguments=$true)][string[]]$ReaArguments)
$ErrorActionPreference = 'Stop'
$configPath = Join-Path $PSScriptRoot 'rea-openleague.config.json'
$config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json
foreach ($entry in @($config.node, $config.rea_entry, (Join-Path $config.ghidra 'support\analyzeHeadless.bat'), (Join-Path $config.java 'bin\javac.exe'))) {
    if (-not (Test-Path -LiteralPath $entry -PathType Leaf)) { throw "Dépendance REA manquante : $entry" }
}
$packagePath = Join-Path (Split-Path (Split-Path $config.rea_entry -Parent) -Parent) 'package.json'
$package = Get-Content -LiteralPath $packagePath -Raw | ConvertFrom-Json
if ($package.version -ne $config.rea_version) { throw 'La version REA a changé ; vérifier le nouveau contrat avant utilisation.' }
if (-not $ReaArguments -or $ReaArguments.Count -eq 0) { $ReaArguments = @('doctor', '--provider', 'ghidra', '--json') }
$variables = @{ GHIDRA_INSTALL_DIR=$config.ghidra; JAVA_HOME=$config.java; REA_ANALYSIS_PROVIDER='ghidra'; REA_GHIDRA_STARTUP_TIMEOUT_MS='600000'; TEMP=$config.temporary_directory; TMP=$config.temporary_directory }
$previous = @{}
New-Item -ItemType Directory -Path $config.temporary_directory -Force | Out-Null
try {
    foreach ($key in $variables.Keys) { $previous[$key]=[Environment]::GetEnvironmentVariable($key,'Process'); [Environment]::SetEnvironmentVariable($key,$variables[$key],'Process') }
    & $config.node $config.rea_entry @ReaArguments
    $reaExitCode = $LASTEXITCODE
} finally {
    foreach ($key in $previous.Keys) { [Environment]::SetEnvironmentVariable($key,$previous[$key],'Process') }
}
exit $reaExitCode
