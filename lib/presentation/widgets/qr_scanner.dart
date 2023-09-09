import 'package:mdw_crew/index.dart';
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
  
  QRViewController? _qrViewController;

  // final MobileScannerController _controller = MobileScannerController();

  Future? _onQrViewCreated(QRViewController controller) async {

    _qrViewController = controller;
    _qrViewController!.resumeCamera();
    try {

      _qrViewController!.scannedDataStream.listen((event) async {
        _qrViewController!.pauseCamera();

        // Navigator.pop(context, event.code);

        await qrData(event.code!);

      });

    } catch (e) {
      if (kDebugMode) {
        print("qr create $e");
      }
    }

    return _qrViewController!;
  }
  
  Future<void> qrData(String data) async {

    try {

      DialogCom().dialogLoading(context);
      
      await widget.func!(data);
      
      await _qrViewController!.resumeCamera();
      
      // Close Dialog Loading
      Navigator.pop(context);
      
    } catch (e) {
      
      // SoundUtil.soundAndVibrate(SOUND);

      // Close Dialog Loading
      Navigator.pop(context);

      await DialogCom().errorMsgCustomButton(context, "Something wrong");
    }

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

                  QRView(
                    key: qrKey,
                    onQRViewCreated: (QRViewController qrView) async {
                      await _onQrViewCreated(qrView);
                    },
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.white,
                      borderRadius: 10,
                      borderWidth: 5,
                      borderLength: 50,
                    ),
                  ),

                  // MobileScanner(
                  //   // startDelay: true,
                  //   controller: _controller,
                  //   errorBuilder: (context, error, child) {
                  //     print("MobileScanner error $error");
                  //     return Container();//ScannerErrorWidget(error: error);
                  //   },
                  //   onDetect: (capture) async {

                  //     await _controller.stop();

                  //     print("capture.barcodes.first.rawValue! ${capture.barcodes.first.rawValue!}");

                  //     // print("capture.barcodes.first.rawValue ${  }");

                  //     await qrData(capture.barcodes.first.rawValue!);

                  //     await _controller.start();
                  //     // setState(() {
                  //     //   this.capture = capture;
                  //     // });
                  //   },
                  // ),

                  SafeArea(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: !(widget.isBackBtn!) ? null : (){
                          Navigator.pop(context);
                        },
                        icon: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            widget.isBackBtn! ? Padding(
                              padding: EdgeInsets.only(top: 5, right: 10),
                              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
                            ) : Container(),
                            
                            AnimatedTextKit(
                              // pause: Duration(milliseconds: 300),
                              repeatForever: true,
                              animatedTexts: [
                                
                                TypewriterAnimatedText(
                                  widget.title!, 
                                  textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
                                  
                                ),
                                // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
                              ],
                            ),
                          ],
                        ),
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
                ]
              )
            ),
          ],
        ),
      ),
    );
  }
}
