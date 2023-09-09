
import 'package:mdw_crew/domain/usecase/membership_uc/membership_uc_impl.dart';
import 'package:mdw_crew/index.dart';

class MembershipScreen extends StatelessWidget {
  
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final MembershipUcImpl membershipUcImpl = MembershipUcImpl();

    membershipUcImpl.setBuildContext = context;

    return QrScanner(title: 'ស្កេនកាតសមាជិក', func: membershipUcImpl.redeem);
    // Consumer<DSCSocketProvider>(
    //   builder: (context, provider, widgets) {
    //     return Container(
    //       color: Colors.green.withOpacity(0.15),
    //       // padding: const EdgeInsets.all(20),
    //       height: MediaQuery.of(context).size.height,
    //       width: MediaQuery.of(context).size.width,
    //       child: Stack(
    //         children: [

    //           MobileScanner(
    //             // startDelay: true,
    //             // controller: _controller,
    //             controller: MobileScannerController(
    //               facing: CameraFacing.back,
    //             ),
    //             errorBuilder: (context, error, child) {
    //               print("errorBuilder $error");
    //               return Container();//ScannerErrorWidget(error: error);
    //             },
    //             onScannerStarted: (arg){
    //               // print("onScannerStarted _controller.events!.isPaused ${_controller.events!.isPaused}");
    //             },
    //             onDetect: (capture) async {
                  
    //               print("onDetect onDetect");
    //               DialogCom().dialogLoading(context);

    //               // print("before onDetect _controller.events!.isPaused ${_controller.events!.isPaused}");
                  
    //               // await _controller.stop();
    //               // _controller.events!.pause();//_controller.stop();

    //               // print("onDetect _controller.events!.isPaused ${_controller.events!.isPaused}");

    //               try {

    //                 decode = json.decode(capture.barcodes.first.rawValue!);

    //                 // Scan Difference QR
    //                 if (decode!.containsKey('type') && decode!.containsKey('addr')){

    //                   // print("capture.barcodes.first.rawValue ${  }");

    //                   await GetRequest.claimBenefit(decode!['addr']).then((value) async {
                        
    //                     // Close Dialog
    //                     Navigator.pop(context);

    //                     // print("value ${value.body}");
    //                     await claimingDialog(value);

    //                     // Reset Decode Variable
    //                     decode = null;

    //                     // await _controller.start();
                        
    //                   });
    //                 } else {

    //                   // Close Dialog
    //                   // ignore: use_build_context_synchronously
    //                   Navigator.pop(context);

    //                   // ignore: use_build_context_synchronously
    //                   await DialogCom().errorMsgCustomButton(
    //                     context, 
    //                     "QR របស់កាតសមាជិកមិនត្រឹមត្រូវ"
    //                   );

    //                   // await _controller.start();
    //                 }
    //               } catch (e) {

    //                 // Close Dialog
    //                 Navigator.pop(context);

    //                 // ignore: use_build_context_synchronously
    //                 await DialogCom().errorMsgCustomButton(
    //                   context, 
    //                   "Something wrong $e"
    //                 );

    //                 // await _controller.start();
    //               }
    //               // setState(() {
    //               //   this.capture = capture;
    //               // });
    //             },
    //           ),

    //           Container(
    //             height: 80,
    //             padding: const EdgeInsets.only(left: 20, top: 20),
    //             child: Align(
    //               alignment: Alignment.topLeft,
    //               child: AnimatedTextKit(
    //                 // pause: Duration(milliseconds: 300),
    //                 repeatForever: true,
    //                 animatedTexts: [
                      
    //                   TypewriterAnimatedText(
    //                     'ស្កេនកាតសមាជិក', 
    //                     textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
                        
    //                   ),
    //                   // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
    //                 ],
    //               ),
    //             ),
    //           ),
              
    //         ],
    //       ),
    //       // QrScanner(title: '', func: redeem),
    //     );
    //   }
    // );
  }
}