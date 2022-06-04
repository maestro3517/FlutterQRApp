import android.annotation.SuppressLint
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.platform.PlatformView;

import android.content.Context
import android.util.DisplayMetrics
import android.util.Log
import android.view.View
import androidx.camera.core.*
import androidx.annotation.NonNull
import androidx.camera.lifecycle.ProcessCameraProvider
import androidx.camera.view.PreviewView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.core.content.res.ResourcesCompat
import com.example.flutter_qr_app.getAspectRatio
import com.google.mlkit.vision.barcode.BarcodeScanner
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.common.InputImage
import androidx.lifecycle.LifecycleOwner;
import com.example.flutter_qr_app.MainActivity

internal class QRView(context: Context,app: MainActivity,messenger: BinaryMessenger) : PlatformView,MethodChannel.MethodCallHandler {
    val TAG = "MainActivity"

    private val previewView = PreviewView(context)
    private val context = context;
    private val app = app;
    private val messenger = messenger;
    private val methodChannel = MethodChannel(messenger,"com.example.flutter_qr_app/qr_code_scanner")
    private lateinit var camera: Camera
    private lateinit var cameraProvider: ProcessCameraProvider

    companion object {
        const val REQUEST_CAMERA_PERMISSION = 1003
    }

    private val screenAspectRatio by lazy {
        val metrics = DisplayMetrics().also { previewView.display.getRealMetrics(it) }
        metrics.getAspectRatio()
    }

    init {
        methodChannel.setMethodCallHandler(this)
        previewView.importantForAccessibility = 0;
        previewView.minimumHeight = 100;
        previewView.minimumWidth = 100;
        previewView.contentDescription = "Description Here";
    }

    private fun startCamera() {
        val cameraProviderFuture = ProcessCameraProvider.getInstance(context)
        cameraProviderFuture.addListener(Runnable {
            val cameraProvider = cameraProviderFuture.get()
            bindPreview(cameraProvider)
        }, ContextCompat.getMainExecutor(context))
    }

    //    @SuppressLint("UnsafeExperimentalUsageError")
    @SuppressLint("UnsafeOptInUsageError")
    private fun bindPreview(camProvider: ProcessCameraProvider) {
        cameraProvider = camProvider

        val previewUseCase = Preview.Builder()
            .setTargetRotation(previewView.display.rotation)
            .setTargetAspectRatio(screenAspectRatio)
            .build().also {
                it.setSurfaceProvider(previewView.surfaceProvider)
            }
        val barcodeScanner = BarcodeScanning.getClient()
        val analysisUseCase = ImageAnalysis.Builder()
            .setTargetRotation(previewView.display.rotation)
            .setTargetAspectRatio(screenAspectRatio)
            .build().also {
                it.setAnalyzer(
                    ContextCompat.getMainExecutor(context)
                ) { imageProxy ->
                    processImageProxy(barcodeScanner, imageProxy)
                }
            }
        val useCaseGroup = UseCaseGroup.Builder().addUseCase(previewUseCase).addUseCase(
            analysisUseCase
        ).build()

        camera = cameraProvider.bindToLifecycle(
            app,
            CameraSelector.Builder().requireLensFacing(CameraSelector.LENS_FACING_BACK).build(),
            useCaseGroup
        )
    }

    //    @SuppressLint("UnsafeExperimentalUsageError")
    @SuppressLint("UnsafeOptInUsageError")
    private fun processImageProxy(barcodeScanner: BarcodeScanner, imageProxy: ImageProxy) {

        // This scans the entire screen for barcodes
        imageProxy.image?.let { image ->
            val inputImage = InputImage.fromMediaImage(image, imageProxy.imageInfo.rotationDegrees)
            barcodeScanner.process(inputImage)
                .addOnSuccessListener { barcodeList ->
                    if (!barcodeList.isNullOrEmpty()) {
                        if (!barcodeList[0].rawValue.isNullOrEmpty()){
                            Log.e(TAG, "processImageProxy: " + barcodeList[0].rawValue)
                            cameraProvider.unbindAll()
//                            setFlashOffIcon()
//                            Snackbar.make(this@MainActivity,binding.clMain,
//                                "${barcodeList[0].rawValue!!}",Snackbar.LENGTH_INDEFINITE)
//                                .setAction("Retry") {
//                                    startCamera()
//                                }
//                                .show()
                        }
                    }
                }.addOnFailureListener {
                    image.close()
                    imageProxy.close()
                    Log.e(TAG, "processImageProxy: ", it)
                }.addOnCompleteListener {
                    image.close()
                    imageProxy.close()
                }
        }
    }


    override fun getView(): View? {
        return previewView;
    }

    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if(call.method == "scan") {
            scanQRCode()
            result.success("worked")
        }
    }

    fun scanQRCode(): String {
        startCamera();
        return ""
    }

}