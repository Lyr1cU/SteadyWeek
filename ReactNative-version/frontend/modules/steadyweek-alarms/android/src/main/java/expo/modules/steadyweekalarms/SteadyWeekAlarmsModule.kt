package expo.modules.steadyweekalarms

import android.app.AlarmManager
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition

class SteadyWeekAlarmsModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("SteadyWeekAlarms")

    Function("canScheduleExactAlarms") {
      canScheduleExactAlarms()
    }

    Function("canUseFullScreenIntent") {
      canUseFullScreenIntent()
    }

    Function("openExactAlarmSettings") {
      openExactAlarmSettings()
    }

    Function("openFullScreenSettings") {
      openFullScreenSettings()
    }
  }

  private fun context(): Context {
    return appContext.reactContext ?: throw IllegalStateException("React context is gone")
  }

  private fun canScheduleExactAlarms(): Boolean {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
      return true
    }
    val alarmManager = context().getSystemService(AlarmManager::class.java) ?: return false
    return alarmManager.canScheduleExactAlarms()
  }

  private fun canUseFullScreenIntent(): Boolean {
    if (Build.VERSION.SDK_INT < 34) {
      return true
    }
    val manager = context().getSystemService(NotificationManager::class.java) ?: return false
    return manager.canUseFullScreenIntent()
  }

  private fun openExactAlarmSettings() {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S) {
      return
    }
    start(
      Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
        data = Uri.parse("package:${context().packageName}")
      }
    )
  }

  private fun openFullScreenSettings() {
    if (Build.VERSION.SDK_INT < 34) {
      return
    }
    start(
      Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
        data = Uri.parse("package:${context().packageName}")
      }
    )
  }

  private fun start(intent: Intent) {
    val activity = appContext.currentActivity
    if (activity != null) {
      activity.startActivity(intent)
    } else {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      context().startActivity(intent)
    }
  }
}
