package com.example.flutter_qr_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.util.DisplayMetrics
import android.util.Log
import androidx.camera.core.*
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import com.google.mlkit.vision.barcode.BarcodeScanner
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.common.InputImage
import io.flutter.plugin.common.MethodCall

class MainActivity : FlutterActivity(),MethodChannel.MethodCallHandler {

    private val CHANNEL = "com.example.flutter_qr_app/main"

    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor,CHANNEL)
        methodChannel.setMethodCallHandler(this)
        flutterEngine
            .platformViewsController
            .registry
            .registerViewFactory("com.example.flutter_qr_app/flutter_qr_app", QRViewFactory(this,flutterEngine.dartExecutor.binaryMessenger))

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    }


}

