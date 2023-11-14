import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:music/views/MusicLover/dj_details.dart';
import 'common.dart';
import 'http_service.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  _ScannerState createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner"),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(
                flex: 1,
                child: Center(
                  child: Text('Scan a code'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      print('_onQRViewCreated' );
      controller.pauseCamera();
      controller.stopCamera();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Sending Message" + scanData.code.toString()),
      // ));
      print('_onQRViewCreated${scanData.code}');
      var scanDataStr = scanData.code.toString();
      var aStr = scanDataStr.replaceAll(RegExp(r'[^0-9]'),'');
      print(aStr);
      getDjByID(aStr);
      // if (await canLaunch(scanData.code)) {
      //   await launch(scanData.code);
      //   controller.resumeCamera();
      // } else {
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text('Could not find viable url'),
      //         content: SingleChildScrollView(
      //           child: ListBody(
      //             children: <Widget>[
      //               Text('Barcode Type: ${describeEnum(scanData.format)}'),
      //               Text('Data: ${scanData.code}'),
      //             ],
      //           ),
      //         ),
      //         actions: <Widget>[
      //           TextButton(
      //             child: Text('Ok'),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //       );
      //     },
      //   ).then((value) => controller.resumeCamera());
      // }
    });
  }

  getDjByID(String id) async {
    EasyLoading.show(status: 'loading...');
    Uri uri = generateUrl('dj-detail/$id');
    var httpClient = HttpService();
    var resp = await httpClient.get(uri);
    if (resp.statusCode == 200) {
      final body = jsonDecode(resp.body);
      var dj = body['dj'];
      print(dj);

      Navigator.of(context).pop();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DjDetailsScreen(dj: dj),
        ),
      );

    } else {
      print(resp.body);
      showToast(message: 'Oops! Something went wrong.');
    }
    EasyLoading.dismiss();
  }
}


