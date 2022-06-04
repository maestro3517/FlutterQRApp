package com.example.flutter_qr_app

import QRView
import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class QRViewFactory(app: MainActivity,messenger: BinaryMessenger): PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private val app = app;
    private val messenger = messenger;

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        return QRView(context!!, app,messenger)
    }

}