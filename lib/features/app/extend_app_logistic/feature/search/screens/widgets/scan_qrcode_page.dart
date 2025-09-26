import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

// import 'package:qrscan/qrscan.dart' as scanner;

class ScanQrcodePage extends StatefulWidget {
  const ScanQrcodePage({Key? key}) : super(key: key);

  @override
  ScanQrcodePageState createState() => ScanQrcodePageState();
}

class ScanQrcodePageState extends State<ScanQrcodePage> {
  GlobalKey key = GlobalKey();
  Uint8List bytes = Uint8List(0);
  // static late TextEditingController idController;
  // static late TextEditingController phoneController;
  // static late TextEditingController totalController;

  Barcode? result;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // final DeliveryBloc deliveryBloc = DeliveryBloc();
  // DeliveryDetailBloc? deliveryDetailBloc;

  Future<bool?> _errorMessage(String? errorMessage) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alert !'),
            content: Text(errorMessage!),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Yes'),
              ),
            ],
          );
        });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  void initState() {
    super.initState();
    // deliveryDetailBloc = DeliveryDetailBloc();
    // idController = TextEditingController();
    // phoneController = TextEditingController();
    // totalController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: Text("Scan QR code"),
          backgroundColor: Colors.transparent,
          elevation: 0),
      // backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(flex: 5, child: _buildQrView(context)),
          // Expanded(
          //   flex: 5,
          //   child: Container(
          //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
          //     child: _qrCodeWidget(this.bytes, context),
          //   ),
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => navigatePageOpenCamera(),
      //   tooltip: 'Open camera',
      //   child: const Icon(Icons.qr_code_scanner),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildQrView(BuildContext c) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      await controller.pauseCamera();
      if (result == null) {
        print("Please scan a correct qr code");
      } else {
        // print(scanData.code.toString());
        String qrResult = scanData.code.toString();
        var scanResult = json.decode(qrResult);
        print("qrResult: ${scanResult.toString()}");
        // searchBloc!.add(SearchStarted(query: scanResult["track_code"]));
        Get.find<ExpressController>(tag: 'filter')
            .trackingDeliveryHistory(id: scanResult.toString());
        Navigator.pop(context, scanResult.toString());
      }
    });
  }

  @override
  void dispose() {
    // controller.dispose();
    // deliveryBloc.close();
    super.dispose();
  }
}
