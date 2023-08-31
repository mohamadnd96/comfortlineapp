import 'package:comfortline/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../code.dart';

class QrScanner extends StatefulWidget {
  final void Function() onError;
  const QrScanner(this.onError, {Key? key}) : super(key: key);
  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  void fillCodeQr(String result) { // added function (called in _onQRViewCreated)
    if (result.startsWith('www.comfortline.com/votes/')) {
      String code = result.substring('www.comfortline.com/votes/'.length-1, result.length-1);
      if (code.length == 8 && int.tryParse(code) != null) { // test if the QR output is 8 integers 
        controller1.text = result[0];
        controller2.text = result[1];
        controller3.text = result[2];
        controller4.text = result[3];
        controller5.text = result[4];
        controller6.text = result[5];
        controller7.text = result[6];
        controller8.text = result[7];
        pop(context); // go back to the main page
      } else {
        pop(context);
        widget.onError(); // error when code is invalid
      }
    } else {
      pop(context);
      widget.onError(); // error when result isn't a valid comfortline link
    }
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  QRViewController? controller;

  void _onQRViewCreated(QRViewController controller) { // automaticaly given when qr code is scanned (called in build function)
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
        child: QRView( // square with camera to scan the QR code
          overlay: QrScannerOverlayShape(borderRadius: 20), // square
          key: qrKey, // just put it there
          onQRViewCreated: _onQRViewCreated, 
        ),
      ),
    );
  }
}
