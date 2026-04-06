# Run Flutter from the project-local SDK (tools\flutter) without global PATH.
# Usage (from life_balance folder):
#   .\flutter-dev.ps1 pub get
#   .\flutter-dev.ps1 gen-l10n
#   .\flutter-dev.ps1 run -d chrome

$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
$flutterBin = Join-Path $root "tools\flutter\bin"

if (-not (Test-Path "$flutterBin\flutter.bat")) {
    Write-Host "Flutter SDK not found at: $flutterBin" -ForegroundColor Red
    Write-Host "From repo root run:" -ForegroundColor Yellow
    Write-Host '  git clone https://github.com/flutter/flutter.git -b stable tools\flutter' -ForegroundColor Gray
    exit 1
}

$env:Path = "$flutterBin;$env:Path"
Set-Location $PSScriptRoot
& flutter @args
exit $LASTEXITCODE
