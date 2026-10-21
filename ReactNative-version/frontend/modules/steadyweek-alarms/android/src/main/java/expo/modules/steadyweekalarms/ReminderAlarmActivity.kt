package expo.modules.steadyweekalarms

import android.app.Activity
import android.graphics.Color
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.WindowManager
import android.widget.LinearLayout
import android.widget.TextView

/** Wakes the lock screen for a routine reminder. Launched by the notification full-screen intent. */
class ReminderAlarmActivity : Activity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
      setShowWhenLocked(true)
      setTurnScreenOn(true)
    } else {
      @Suppress("DEPRECATION")
      window.addFlags(
        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
          WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
      )
    }
    window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

    val title = intent.getStringExtra(EXTRA_TITLE) ?: "SteadyWeek"
    val body = intent.getStringExtra(EXTRA_BODY) ?: ""
    val density = resources.displayMetrics.density

    val root = LinearLayout(this).apply {
      orientation = LinearLayout.VERTICAL
      gravity = Gravity.CENTER_HORIZONTAL
      setBackgroundColor(Color.parseColor("#0C0C12"))
      val pad = (28 * density).toInt()
      setPadding(pad, (96 * density).toInt(), pad, pad)
    }

    val titleView = TextView(this).apply {
      text = title
      setTextColor(Color.parseColor("#CAB8FF"))
      setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
      gravity = Gravity.CENTER
    }

    val bodyView = TextView(this).apply {
      text = body
      setTextColor(Color.parseColor("#E8E6F2"))
      setTextSize(TypedValue.COMPLEX_UNIT_SP, 32f)
      setTypeface(typeface, Typeface.BOLD)
      gravity = Gravity.CENTER
      setPadding(0, (28 * density).toInt(), 0, (48 * density).toInt())
    }

    val button = TextView(this).apply {
      text = "OK"
      setTextColor(Color.parseColor("#1A1530"))
      setTextSize(TypedValue.COMPLEX_UNIT_SP, 18f)
      setTypeface(typeface, Typeface.BOLD)
      gravity = Gravity.CENTER
      val h = (18 * density).toInt()
      val v = (14 * density).toInt()
      setPadding(h, v, h, v)
      background = GradientDrawable().apply {
        cornerRadius = 16 * density
        setColor(Color.parseColor("#CAB8FF"))
      }
      setOnClickListener { finish() }
    }

    root.addView(titleView, LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.MATCH_PARENT,
      LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    root.addView(bodyView, LinearLayout.LayoutParams(
      LinearLayout.LayoutParams.MATCH_PARENT,
      LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    root.addView(button, LinearLayout.LayoutParams(
      (180 * density).toInt(),
      LinearLayout.LayoutParams.WRAP_CONTENT
    ))
    setContentView(root)
  }

  companion object {
    const val EXTRA_TITLE = "title"
    const val EXTRA_BODY = "body"
    const val CLASS_NAME = "expo.modules.steadyweekalarms.ReminderAlarmActivity"
  }
}
