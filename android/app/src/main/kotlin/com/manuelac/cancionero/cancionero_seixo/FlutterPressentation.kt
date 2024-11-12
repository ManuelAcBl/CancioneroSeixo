package com.manuelac.cancionero.cancionero_seixo

import android.app.Presentation
import android.content.Context
import android.os.Bundle
import android.os.PowerManager
import android.view.Display
import android.widget.FrameLayout
import io.flutter.FlutterInjector
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class FlutterPresentation(context: Context, display: Display) : Presentation(context, display) {

    private var channel: MethodChannel? = null
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyApp::PresentationWakeLock")
        wakeLock?.acquire()

        val flutterEngine = FlutterEngine(context).apply {
            val path = FlutterInjector.instance().flutterLoader().findAppBundlePath()
            val entrypoint = DartExecutor.DartEntrypoint(path, "presentationMain")

            channel = MethodChannel(dartExecutor.binaryMessenger, "presentation_data_channel")

            dartExecutor.executeDartEntrypoint(entrypoint, listOf(display.displayId.toString()))
            lifecycleChannel.appIsResumed()

            FlutterEngineCache.getInstance().put("presentation", this)
        }

        val frame = FrameLayout(context).apply {
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT
            )

            addView(FlutterView(context).apply { attachToFlutterEngine(flutterEngine) })
        }

        setContentView(frame)
    }

    override fun onDetachedFromWindow() {
        super.onDetachedFromWindow()
        // Release the wake lock when the presentation is detached
        wakeLock?.let {
            if (it.isHeld) {
                it.release()
            }
        }
    }
}