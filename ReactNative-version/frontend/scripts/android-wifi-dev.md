# Install dev build on phone over Wi‑Fi (ADB)

Phone and PC on the same Wi‑Fi. **Wireless debugging** enabled on Android (Developer options).

## Windows: `adb` not found

ADB is installed with Android Studio but often not in PATH. Use the full path (adjust username if needed):

```powershell
$adb = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
```

Or add for the current PowerShell session:

```powershell
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
```

## Connect and install

On the phone, open **Wireless debugging** and copy **IP address & port** (port changes each time).

**Easiest — run the script** (do not paste `PS E:\...>` lines from the terminal):

```powershell
cd E:\PrProjects\SteadyWeek\ReactNative-version\frontend
.\scripts\adb-env.ps1
adb connect 192.168.31.146:41183
.\scripts\android-dev.ps1
```

Or one step with connect:

```powershell
cd E:\PrProjects\SteadyWeek\ReactNative-version\frontend
.\scripts\android-dev.ps1 -Connect "192.168.31.146:41183"
```

Or add for the current PowerShell session:

```powershell
$env:Path += ";$env:LOCALAPPDATA\Android\Sdk\platform-tools"
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$env:JAVA_HOME = "${env:ProgramFiles}\Android\Android Studio\jbr"
$env:Path += ";$env:JAVA_HOME\bin"
```

(`android-dev.ps1` sets ANDROID_HOME, JAVA_HOME, and PATH automatically.)

When `adb devices` shows `device`, the build can install.

First build can take 10–20 minutes. Open **SteadyWeek** (dev app), not Expo Go.

Profile → **Test notification (5 sec)** after allowing notifications.

To disconnect: `& $adb disconnect 192.168.31.146:41183`
