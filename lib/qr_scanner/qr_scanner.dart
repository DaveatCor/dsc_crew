import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mdw_crew/backend/get_api.dart';
import 'package:mdw_crew/components/dialog_c.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/provider/mdw_socket_p.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {

  /// func example: 
  /// func!('', data);
  final Function? func;
  final String? title;
  final String? hallId;
  final bool? isBackBtn;

  const QrScanner({Key? key, required this.title, required this.func, this.hallId, this.isBackBtn = false}) : super(key: key);

  // final List portList;
  // final WalletSDK sdk;
  // final Keyring keyring;

  // QrScanner({this.portList, this.sdk, this.keyring});

  @override
  State<StatefulWidget> createState() {
    return QrScannerState();
  }
}

class QrScannerState extends State<QrScanner> {

  final GlobalKey qrKey = GlobalKey();
  
  // QRViewController? _qrViewController;

  final MobileScannerController _controller = MobileScannerController();

  // Future? _onQrViewCreated(QRViewController controller) async {

  //   _qrViewController = controller;
  //   _qrViewController!.resumeCamera();
  //   try {

  //     _qrViewController!.scannedDataStream.listen((event) async {
  //       _qrViewController!.pauseCamera();

  //       // Navigator.pop(context, event.code);

  //       await qrData(event.code!);

  //     });

  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("qr create $e");
  //     }
  //   }

  //   return _qrViewController!;
  // }
  
  Future<void> qrData(String data) async {
    print("qrData function ${data.contains('qrcode')}");
    DialogCom().dialogLoading(context);
    
    await widget.func!('', data);
    
    // await _qrViewController!.resumeCamera();
    
    // Close Dialog Loading
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: widget.isBackBtn == true ? AppBar(
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(
      //     color: Colors.black
      //   ),
      //   title: AnimatedTextKit(
      //     repeatForever: true,
      //     pause: const Duration(seconds: 1),
      //     animatedTexts: [

      //       TypewriterAnimatedText(
      //         widget.title!,
      //         textAlign: TextAlign.center,
      //         textStyle: TextStyle(
      //           fontSize: 16,
      //           color: Colors.black,
      //           fontWeight: FontWeight.w700,
      //         ),
      //       ),

      //     ],
      //   ),

      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.black,
      //     ),
      //   ),

      //   actions: [
      //     Container(
      //       margin: EdgeInsets.only(right: 15),
      //       child: Align(
      //         alignment: Alignment.center,
      //         child: widget.hallId == null 
      //         ? Container() 
      //         : Consumer<DSCSocketProvider>(
      //           builder: (context, provider, child) {
      //             return AnimatedTextKit(
      //               // pause: Duration(milliseconds: 300),
      //               repeatForever: true,
      //               animatedTexts: [
                      
      //                 FadeAnimatedText(
      //                   widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), 
      //                   textStyle: TextStyle(color: Color.fromARGB(255, 0, 234, 8), fontSize: 19, fontWeight: FontWeight.bold),
      //                   duration: Duration(
      //                     milliseconds: 2000
      //                   )
      //                 ),
      //                 // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
      //               ],
      //               onTap: () {
      //               },
      //             );
                  
      //           }
      //         )
      //       ),
      //     )
      //   ],
      // ) : null,

      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            
            Expanded(
              child: Stack(
                children: [

                  MobileScanner(
                    // startDelay: true,
                    controller: _controller,
                    errorBuilder: (context, error, child) {
                      print("MobileScanner error $error");
                      return Container();//ScannerErrorWidget(error: error);
                    },
                    onDetect: (capture) async {

                      await _controller.stop();

                      print("capture.barcodes.first.rawValue! ${capture.barcodes.first.rawValue!}");

                      // print("capture.barcodes.first.rawValue ${  }");

                      await qrData(capture.barcodes.first.rawValue!);

                      await _controller.start();
                      // setState(() {
                      //   this.capture = capture;
                      // });
                    },
                  ),

                  SafeArea(
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          widget.isBackBtn! ? IconButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
                          ) : Container(),
                          
                          AnimatedTextKit(
                            // pause: Duration(milliseconds: 300),
                            repeatForever: true,
                            animatedTexts: [
                              
                              TypewriterAnimatedText(
                                'ស្កេនសំបុត្រ', 
                                textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
                                
                              ),
                              // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // MobileScanner(
                  //   // startDelay: true,
                  //   controller: MobileScannerController(torchEnabled: false),
                  //   errorBuilder: (context, error, child) {
                  //     return Container();//ScannerErrorWidget(error: error);
                  //   },
                  //   onDetect: (capture) async {
                  //     await DialogCom().dialogMessage(context, title: MyText(text: capture.barcodes.first.rawValue,));
                  //     // setState(() {
                  //     //   this.capture = capture;
                  //     // });
                  //   },
                  // )
                  // QRView(
                  //   key: qrKey,
                  //   onQRViewCreated: (QRViewController qrView) async {
                  //     await _onQrViewCreated(qrView);
                  //   },
                  //   // overlay: QrScannerOverlayShape(
                  //   //   borderColor: Colors.white,
                  //   //   borderRadius: 10,
                  //   //   borderWidth: 5,
                  //   //   borderLength: 50,
                  //   // ),
                  // ),
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
