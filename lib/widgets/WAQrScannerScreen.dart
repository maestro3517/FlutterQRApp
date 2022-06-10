import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_qr_app/httpClient.dart';
import 'package:flutter_qr_app/widgets/MWDataTableScreen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_qr_app/constants.dart' as constants;

const WAPrimaryColor = Color(0xFF6C56F9);
const WAAccentColor = Color(0xFF26C884);


class WAQrScannerScreen extends StatefulWidget {
  static String tag = '/WAQrScannerScreen';

  @override
  WAQrScannerScreenState createState() => WAQrScannerScreenState();
}

class WAQrScannerScreenState extends State<WAQrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
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
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.dark);
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

    if(scanData.gmsErrors.isEmpty) {
      final data = scanData.data;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MWDataTableScreen()),
      );
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
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/login');
              storage.clear();
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
    controller.scannedDataStream.listen((scanData) {
      final code = scanData.code;
      if(code != null && code.isNotEmpty) {
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
    return WillPopScope(onWillPop: _onWillPop, child: Scaffold(
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
                }).paddingOnly(top: 8, right: 16),
              ),
              30.height,
              Text('Hold  your Card inside the frame', style: boldTextStyle(color: Colors.white, size: 18)),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(borderRadius: radius(30), backgroundColor: Colors.white),
              child: Icon(Icons.close, color: primaryColor),
            ).onTap(() {
              finish(context);
            }),
          ).paddingBottom(60),
        ],
      ),
    ));
  }
}
