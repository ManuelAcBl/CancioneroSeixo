package com.manuelac.cancionero.cancionero_seixo

import android.app.Presentation
import android.content.Context
import android.content.Intent
import android.hardware.display.DisplayManager
import android.os.Build
import android.provider.Settings
import android.view.Display
import androidx.annotation.RequiresApi
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    val channel: String = "com.manuelac.cancionero/presenation"
    private val eventChannel: String = "com.manuelac.cancionero/screens_event"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val binaryMessenger: BinaryMessenger = flutterEngine.dartExecutor.binaryMessenger

        val event = DisplaysEvent(context);

        EventChannel(binaryMessenger, eventChannel).setStreamHandler(event)

        MethodChannel(binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDisplays" -> result.success(Gson().toJson(getResultDisplays(context)))

                "showPresentation" -> {
                    val displayId: Int = call.argument<Int>("displayId")!!

                    showPresentation(displayId, context)

                    result.success(true)
                    event.sendDisplayInfo()
                }

                "hidePresentation" -> {
                    val displayId: Int = call.argument<Int>("displayId")!!

                    val presentation: Presentation?
                    try {
                        presentation = presentations.first { it.display.displayId == displayId }

                        presentations -= presentation
                        presentation.dismiss()

                        result.success(true)
                        event.sendDisplayInfo()

                    } catch (e: Exception) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                }

                "openSettings" -> {
                    startActivity(Intent(Settings.ACTION_CAST_SETTINGS))
                }

                else -> result.notImplemented()
            }
        }
    }

    companion object {
        private var presentations: List<FlutterPresentation> = listOf()

        fun getDisplays(context: Context): Array<Display> {
            val displayManager: DisplayManager = context.getSystemService(DISPLAY_SERVICE) as DisplayManager
            return displayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)
        }

        fun showPresentation(displayId: Int, context: Context) {
            val display: Display = getDisplays(context).first { it.displayId == displayId }
            val presentation = FlutterPresentation(context, display)
            presentation.show()

            presentations += presentation
        }

        fun getResultDisplays(context: Context): List<ResultDisplay> {
            val displays: Array<Display> = getDisplays(context)

            val resultDisplays: List<ResultDisplay> = displays.map { display ->
                ResultDisplay(
                    id = display.displayId,
                    width = display.mode.physicalWidth,
                    height = display.mode.physicalHeight,
                    name = display.name,
                    refreshRate = display.refreshRate,
                    selected = presentations.any { it.display.displayId == display.displayId },
                )
            }

            return resultDisplays;
        }
    }
}
