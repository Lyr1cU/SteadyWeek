# Allow Metro (8081) from phone on Wi-Fi — run PowerShell as Administrator

New-NetFirewallRule -DisplayName "SteadyWeek Expo Metro 8081" `
  -Direction Inbound `
  -Protocol TCP `
  -LocalPort 8081 `
  -Action Allow `
  -Profile Private `
  -ErrorAction SilentlyContinue

Write-Host "Rule added (or already exists). Metro: http://192.168.31.232:8081"
Write-Host "If phone still fails: disable AP/client isolation on the router, or use adb reverse (see android-wifi-dev.md)."
