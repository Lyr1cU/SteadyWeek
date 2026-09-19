# SteadyWeek - Android dev build over Wi-Fi ADB
# Usage:
#   .\scripts\android-dev.ps1
#   .\scripts\android-dev.ps1 -Connect "192.168.31.146:41183"

param(
  [string]$Connect = ""
)

$ErrorActionPreference = "Stop"

$sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$platformTools = Join-Path $sdk "platform-tools"
$adb = Join-Path $platformTools "adb.exe"

if (-not (Test-Path $adb)) {
  Write-Error "adb not found at $adb. Install Android Studio SDK."
}

$env:ANDROID_HOME = $sdk
$env:Path = "$env:Path;$platformTools"

$jbrCandidates = @(
  (Join-Path ${env:ProgramFiles} "Android\Android Studio\jbr"),
  (Join-Path $env:LOCALAPPDATA "Programs\Android Studio\jbr")
)
$javaHome = $null
foreach ($candidate in $jbrCandidates) {
  if (Test-Path (Join-Path $candidate "bin\java.exe")) {
    $javaHome = $candidate
    break
  }
}
if (-not $javaHome) {
  Write-Error "JAVA_HOME not found. Install Android Studio or set JAVA_HOME to a JDK 17+ folder."
}
$env:JAVA_HOME = $javaHome
$env:Path = "$env:Path;" + (Join-Path $javaHome "bin")

$gradleHome = "E:\gradle-home"
if (-not (Test-Path $gradleHome)) {
  New-Item -ItemType Directory -Path $gradleHome -Force | Out-Null
}
$env:GRADLE_USER_HOME = $gradleHome

Write-Host "ANDROID_HOME=$env:ANDROID_HOME"
Write-Host "JAVA_HOME=$env:JAVA_HOME"
Write-Host "GRADLE_USER_HOME=$env:GRADLE_USER_HOME"
& $adb version

if ($Connect) {
  Write-Host "Connecting $Connect ..."
  & $adb connect $Connect
}

& $adb devices

$deviceLines = (& $adb devices) | Select-Object -Skip 1 | Where-Object { $_ -match "`tdevice$" }
if ($deviceLines.Count -gt 1) {
  Write-Host "Multiple devices - using first. To pick one: adb -s SERIAL reverse ..."
}
$serial = ($deviceLines | Select-Object -First 1) -replace "`tdevice.*", ""
if ($serial) {
  Write-Host "adb reverse on $serial ..."
  & $adb -s $serial reverse tcp:8081 tcp:8081
  & $adb -s $serial reverse tcp:8097 tcp:8097
}

$frontend = Split-Path $PSScriptRoot -Parent
Set-Location $frontend
Write-Host "Keep npm start running in another terminal (port 8081)."
Write-Host 'Running npm run android:dev (--no-bundler) in' $frontend
npm run android:dev
