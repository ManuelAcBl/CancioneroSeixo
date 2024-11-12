package com.manuelac.cancionero.cancionero_seixo

import android.content.Context
import android.hardware.display.DisplayManager
import com.google.gson.Gson
import io.flutter.plugin.common.EventChannel

class DisplaysEvent(private val context: Context) : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var displayManager: DisplayManager

    private val displayListener = object : DisplayManager.DisplayListener {
        override fun onDisplayAdded(displayId: Int) {
            MainActivity.showPresentation(displayId, context)
            sendDisplayInfo()
        }

        override fun onDisplayRemoved(displayId: Int) = sendDisplayInfo()

        override fun onDisplayChanged(displayId: Int) = sendDisplayInfo()
    }

    public fun sendDisplayInfo() {
        eventSink?.success(Gson().toJson(MainActivity.getResultDisplays(context)))
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        displayManager.registerDisplayListener(displayListener, null)
        sendDisplayInfo()
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        displayManager.unregisterDisplayListener(displayListener)
    }
}