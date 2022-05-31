package com.example.flutter_qr_app

import androidx.annotation.NonNull

import android.app.Activity
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** FlutterBarcodeScanPlugin */
class FlutterBarcodeScanPlugin : FlutterPlugin,
        MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel

    private var activity: Activity? = null

    var result: Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_barcode_scan")
        channel.setMethodCallHandler(this)
    }

    // companion object {
    //   @JvmStatic
    //   fun registerWith(registrar: Registrar) {
    //     val channel = MethodChannel(registrar.messenger(), "com.apptreesoftware.barcode_scan")
    //     val plugin = BarcodeScanPlugin(registrar)
    //     channel.setMethodCallHandler(plugin)
    //     registrar.addActivityResultListener(plugin)
    //   }
    // }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else if (call.method == "scan") {
            this.result = result
            showBarcodeView()
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    private fun showBarcodeView() {
        if (activity == null) {
            Log.e("BarcodeScanPlugin", "plugin can't launch scan activity, because plugin is not attached to any activity.")
            return
        }
        activity?.let { activity ->
            val intent = Intent(activity, MainActivity::class.java)
            activity.startActivityForResult(intent, 100)
        }
    }

    override fun onActivityResult(code: Int, resultCode: Int, data: Intent?): Boolean {
        if (code == 100) {
            if (resultCode == Activity.RESULT_OK) {
                val barcode = data?.getStringExtra("SCAN_RESULT")
                barcode?.let { this.result?.success(barcode) }
            } else {
                val errorCode = data?.getStringExtra("ERROR_CODE")
                if (errorCode != null) {
                    this.result?.error(errorCode, null, null)
                }
            }
            return true
        }
        return false
    }
}