import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_app/httpClient.dart';
import 'package:flutter_qr_app/widgets/QRDataDisplay.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_qr_app/constants.dart' as constants;

class WAQrScannerScreen extends StatefulWidget {
  static String tag = '/WAQrScannerScreen';

  @override
  WAQrScannerScreenState createState() => WAQrScannerScreenState();
}

class WAQrScannerScreenState extends State<WAQrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  final ImagePicker _picker = ImagePicker();
  final LocalStorage storage = LocalStorage(constants.localStorageKey);

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent,
        statusBarIconBrightness: Brightness.dark);
    controller?.dispose();
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).primaryColor,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 300,
      ),
    );
  }

  Future<void> processCode(String qrCode) async {
    await controller?.pauseCamera();
    final scanData = await getScanData(qrCode);

    if (scanData.gmsErrors.isEmpty) {
      final data = scanData.data;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => QrDataDisplay(data: data)),
      ).then((value) => setState(() async {
        await controller?.resumeCamera();
      }));
    }
  }

  Future<void> analyzeImage() async {
    await controller?.pauseCamera();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    final qrCode = await controller?.analyzeImage(image!.path);
    if (qrCode != null) {

      final scanData = await getScanData(qrCode);

      if (scanData.gmsErrors.isEmpty) {
        final data = scanData.data;
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QrDataDisplay(data: data)),
        ).then((value) => setState(() async {
          await controller?.resumeCamera();
        }));
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    // call resumeCamera function
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      final qrCode=scanData.code;

      if (qrCode != null && qrCode.isNotEmpty) {
          processCode(qrCode);
      }
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return( Scaffold(
      body: Stack(
        children: [
          _buildQrView(context),
          Column(
            children: [
              30.height,
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ).onTap(() {
                  finish(context);
                }).paddingOnly(top: 18, right: 16),
              ),
              Text('Hold your QR inside the frame',
                  style: boldTextStyle(color: Colors.white, size: 18)).paddingOnly(top: 18),

            ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).primaryColor),
                ),
                child: const Text("Import QR From Gallery"),
              ).onTap(() {
                analyzeImage();
              }).paddingOnly(bottom: 30),
            ),

        ],
      ),
    )
    );
  }
}