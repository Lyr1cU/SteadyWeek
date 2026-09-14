# PATH + adb devices (no build)

$sdk = Join-Path $env:LOCALAPPDATA "Android\Sdk"
$platformTools = Join-Path $sdk "platform-tools"
$adb = Join-Path $platformTools "adb.exe"
$env:ANDROID_HOME = $sdk
$env:Path = "$env:Path;$platformTools"

Write-Host "adb:" $adb
& $adb devices

Write-Host ""
Write-Host "Connect Wi-Fi (replace port from phone):"
Write-Host "  adb connect 192.168.31.146:PORT"
Write-Host ""
Write-Host "Then build:"
Write-Host "  .\scripts\android-dev.ps1 -Connect `"192.168.31.146:PORT`""
