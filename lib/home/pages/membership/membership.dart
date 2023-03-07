import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:mdw_crew/backend/get_api.dart';
import 'package:mdw_crew/backend/post_api.dart';
import 'package:mdw_crew/components/dialog_c.dart';
import 'package:mdw_crew/components/event_card_c.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/model/benefit_m.dart';
import 'package:mdw_crew/provider/mdw_socket_p.dart';
import 'package:mdw_crew/qr_scanner/qr_scanner.dart';
import 'package:mdw_crew/tool/sound.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:event_crew/event_crew.dart' as event_crew;

class Membership extends StatefulWidget {
  const Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {

  Map<String, dynamic>? decode;

  List<Benefit> selectedItems = [];

  List<Map<String, dynamic>> selectedIndex = [];

  List<Benefit>? benefits;

  List<Map<String, dynamic>>? matches;

  double iconSize = 35;

  bool? _isSuccess = false;

  final MobileScannerController _controller = MobileScannerController();

  Future<bool> redeem(String eventId, String data) async {

    _isSuccess = false;

    try {

      await PostRequest.addmissionFunc(qrcodeData: data).then((value) async {

        if ( ((await json.decode(value.body))['status']).toString().toUpperCase() == 'SUCCESS'){

          _isSuccess = false;

          SoundUtil.soundAndVibrate('mixkit-confirmation-tone-2867.wav');

          // Provider.of<MDWSocketProvider>(context, listen: false).emitSocket('check-in', {'hallId': "vga"});

          // ignore: use_build_context_synchronously
          await DialogCom().dialogMessageNoClose(
            context,
            title: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: SizedBox(
                width: 30,
                child: Lottie.asset(
                  "assets/animation/successful.json",
                  repeat: true,
                  reverse: true,
                  height: 100
                ),
              ),
            ), 
            action: Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const MyText(text: "បិទ", top: 20, bottom: 20, color2: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            content: MyText(text: json.decode(value.body)['message'], fontWeight: FontWeight.w500, left: 10, right: 10, bottom: 10,)
            
          );

        }
        // Invalid QR 
        else {
          
          SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');
          // ignore: use_build_context_synchronously
          await event_crew.DialogCom().errorMsg(
            context,
            json.decode(value.body)['message']
          );

        }
        
      });

      return _isSuccess!;

    } catch (er) {

      SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

      await event_crew.DialogCom().errorMsg(
        context,
        'Something when wrong'
      );

      // DialogCom().dialogMessage(
      //   context, 
      //   title: ClipRRect(
      //     borderRadius: BorderRadius.circular(100),
      //     child: SizedBox(
      //       width: 30,
      //       child: Lottie.asset(
      //         "assets/animation/failed.json",
      //         repeat: true,
      //         reverse: true,
      //         height: 100
      //       ),
      //     ),
      //   ), 
      //   // ignore: unnecessary_null_comparison
      //   content: const MyText(text: "", fontWeight: FontWeight.w500, left: 10, right: 10,)
      // );

      return _isSuccess!;
    }
  }

  initCamera() async {

    await _controller.stop();
    // if (_controller.isStarting == false){

      setState(() {});
    // }
  }

  Future<void> claimingDialog(Response value) async {

    print("value $value");

    // Response value = Response(json.encode({"_id":"64070a335ec86b0c9f28cbdd","userId":"63f6d942187c33db47756b68","membershipPackageId":"63db392708c7e10fced41afe",
    //                             "claim_benefits": [
    //                               {
    //                                 "name": "Home Jersey",
    //                                 "status" :false,
    //                               },
    //                               {
    //                                 "name": "Suzuki Jaccs",
    //                                 "status":false
    //                               },
    //                               {
    //                                 "name": "Brown",
    //                                 "status": false
    //                               },
    //                               {
    //                                 "name": "The Ground market",
    //                                 "status": false
    //                               },
    //                               {
    //                                 "name": "Potato Cornor",
    //                                 "status": false,
    //                               },
    //                               {
    //                                 "name": "Metro",
    //                                 "status": false
    //                               },
    //                               {
    //                                 "name": "Amazon",
    //                                 "status": false,
    //                               },
    //                               {
    //                                 "name": "Cristal Chicken",
    //                                 "status": false
    //                               },
    //                               {
    //                                 "name": "Dek Cha",
    //                                 "status": true,
    //                               },
    //                               {
    //                                 "name": "Ten11 Zando",
    //                                 "status": true
    //                               }
    //                             ],"no":"821501","cardImage":"0x379D31eC307FC4F8EadAE0D32969ABF4FB534AC5.png","isGift":false,"createdAt":"2023-02-16T04:51:26.605Z","updatedAt":"2023-03-06T07:26:21.240Z","__v":0,"id":"64070a335ec86b0c9f28cbdd"}), 200);
    decode = json.decode(value.body);

    benefits = Benefit().filter(List<Map<String, dynamic>>.from(decode!['claim_benefits']));

    // selectedItems =
    print(benefits!.where((element) => element.status == true ? true : false).toList());

    await FilterListDialog.display<Benefit>(
      context,
      listData: benefits!,
      selectedListData: selectedItems,
      
      choiceChipBuilder: (context, wg, status){
        print("wg ${wg.name} ${wg.status}");
        return Card(
          color: wg.status == true ? Colors.blue[900] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Image.network(wg.img, width: 10, height: 10,),
                MyText(text: wg.name.toString(), fontWeight: FontWeight.w700,)
              ],
            ),
          ),
        );
      },
      choiceChipLabel: (keys) {
        return keys!.name;
      },
      validateSelectedItem: (list, val) {
        // selectedIndex.add(benefits.indexOf(val));
        return list!.contains(val);
      },
      onItemSearch: (user, query) {
        return false;// user.name!.toLowerCase().contains(query.toLowerCase());
      },
      allButtonText: "ទាំងអស់",
      resetButtonText: "សារដើម",
      applyButtonText: "យល់ព្រម",
      barrierDismissible: false,
      hideSearchField: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      onApplyButtonClick: (list) async {
        print("list $list");
        selectedIndex.clear();
        
        for(var e in list!){

          selectedIndex.add({
            "index": benefits!.indexOf(e),
            "status": true
          });
        }

        await submitUpdate();

      },
    );
  }

  Future<void> submitUpdate() async {

    try {

      DialogCom().dialogLoading(context);

      await PostRequest.claimBenefits(decode!['_id'], selectedIndex).then((value) async {
        print("value ${value.body}");
        if (value.statusCode == 200 && json.decode(value.body)['message'].toString().toLowerCase() == "updated successfully!") {

          // Close Dialog
          // ignore: use_build_context_synchronously
          Navigator.pop(context);

          await event_crew.DialogCom().successMsg(
            context, json.decode(value.body)['message']
          );

          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          throw Exception(json.decode(value.body));
        }
      });


    } catch (e) {

      // Close Dialog
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      await event_crew.DialogCom().errorMsg(
        context, e.toString()
      );
    }
  }

  @override
  void initState() {
    initCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DSCSocketProvider>(
      builder: (context, provider, widgets) {
        return Container(
          color: Colors.green.withOpacity(0.15),
          // padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [

              MobileScanner(
                // startDelay: true,
                controller: _controller,
                errorBuilder: (context, error, child) {
                  print("error $error");
                  return Container();//ScannerErrorWidget(error: error);
                },
                onDetect: (capture) async {

                  await _controller.stop();

                  // print("capture.barcodes.first.rawValue ${  }");

                  await GetRequest.claimBenefit( await (json.decode(capture.barcodes.first.rawValue!))['addr'] ).then((value) async {
                    
                    print("value ${value.body}");
                    await claimingDialog(value);
                    
                  });

                  await _controller.start();
                  // setState(() {
                  //   this.capture = capture;
                  // });
                },
              ),

              Container(
                height: 80,
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: AnimatedTextKit(
                    // pause: Duration(milliseconds: 300),
                    repeatForever: true,
                    animatedTexts: [
                      
                      TypewriterAnimatedText(
                        'ស្កេនកាតសមាជិក', 
                        textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
                        
                      ),
                      // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
                    ],
                  ),
                ),
              ),
              
            ],
          ),
          // QrScanner(title: '', func: redeem),
        );
      }
    );
  }
}