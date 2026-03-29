package com.example.verygoodcore.parker_flutter_lab

import android.app.AlertDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.example.parker_flutter_lab/alert"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "showAlert" -> {
                    val title = call.argument<String>("title") ?: "提示"
                    val message = call.argument<String>("message") ?: ""
                    showNativeAlert(title, message)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun showNativeAlert(title: String, message: String) {
        AlertDialog.Builder(this)
            .setTitle(title)
            .setMessage(message)
            .setPositiveButton("確定") { dialog, _ -> dialog.dismiss() }
            .show()
    }
}
