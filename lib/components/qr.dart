import 'package:comfortline/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../code.dart';

class QrScanner extends StatefulWidget {
  void Function() onError;
  QrScanner(this.onError, {Key? key}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  void fillCodeQr(String result) {
    if (result.length == 8 && int.tryParse(result) != null) {
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
    controller.scannedDataStream.first.then((scanData) {
      fillCodeQr(scanData.code.toString());
    });
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
