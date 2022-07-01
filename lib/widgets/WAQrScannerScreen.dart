import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_app/httpClient.dart';
import 'package:flutter_qr_app/widgets/QRDataDisplay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to logout'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).popAndPushNamed('/login');
                  controller?.pauseCamera();
                  logout();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    // call resumeCamera fucntion
    controller.resumeCamera();

    controller.scannedDataStream.listen((scanData) {
      String? code = scanData.code?.replaceAll(RegExp(r'[^0-9]'), '');
      if (code != null && code.isNotEmpty) {
        processCode(code);
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
    final primaryColor = Theme.of(context).primaryColor;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            children: [
              _buildQrView(context),
              Column(
                children: [
                  30.height,
                  Align(
                    alignment: Alignment.center,
                    heightFactor: 5,
                    child: Text('Hold  your Card inside the frame',
                        style: boldTextStyle(color: Colors.white, size: 18)),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  width: 200,
                  child: Center(
                    child: MaterialButton(
                      onPressed: analyzeImage,
                      color: Theme.of(context).primaryColor,
                      child: const Text("Import QR From Gallery"),
                    ),
                  ),
                ),
              ).paddingBottom(100),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(30), backgroundColor: Colors.white),
                  child: Icon(Icons.close, color: primaryColor),
                ).onTap(() async {
                  await _onWillPop();
                }),
              ).paddingBottom(10),
            ],
          ),
        ));
  }
}
