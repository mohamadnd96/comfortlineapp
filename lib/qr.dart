import 'package:comfortline/functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../code.dart';

class QrScanner extends StatefulWidget {
  final void Function() onError;
  const QrScanner(this.onError, {Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  void fillCodeQr(String result) {
    const String website = 'https://test1-8f077.web.app/#/login?space=';
    if (result.startsWith(website) &&
        result.length == website.length + 8 &&
        int.tryParse(result.substring(website.length)) != null) {
      controller1.text = result[0];
      controller2.text = result[1];
      controller3.text = result[2];
      controller4.text = result[3];
      controller5.text = result[4];
      controller6.text = result[5];
      controller7.text = result[6];
      controller8.text = result[7];
      pop(context);
    } else {
      pop(context);
      widget.onError();
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    if (controller.hasPermissions) {
      controller.scannedDataStream.first.then((scanData) {
        fillCodeQr(scanData.code.toString());
      });
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: QRView(
          overlay: QrScannerOverlayShape(borderRadius: 20),
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
      ),
    );
  }
}
