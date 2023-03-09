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

  List<Benefit>? tmpBenefits;

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

//     Response value = Response(json.encode({
// 	"_id": "64070a335ec86b0c9f28cbdd",
// 	"userId": "63fef9817b8ae45c7d1261b8",
// 	"membershipPackageId": "63db392708c7e10fced41aff",
// 	"no": "751755",
// 	"cardImage": "0xf78128b3687f05657C6c1E340ba14975253d8B66.png",
// 	"claim_benefits": [
// 		{
// 			"name": "home_jersey",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmYjXfT57Xd52jdouP2Au992xZ2k6enBikLF1cWnk8ZnRk"
// 		},
// 		{
// 			"name": "scarf",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmTjEVpMkyNtyjXs4o2WENiey1a69WvC4GS8KVHqcyaSrV"
// 		},
// 		{
// 			"name": "suzuki_jaccs",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmfBZ1Shzd7ry3AuxUMjELcNRZkDQpkCb7BVNc1zDpLM4h"
// 		},
// 		{
// 			"name": "brown",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmbX2De3uWaM1PtNpJijwzqqMee2ruc8tu1t3wqjMHDkPX"
// 		},
// 		{
// 			"name": "the_ground_market",
// 			"status": false,
// 			"img": "https://gateway.kumandra.org/files/QmXx1SpyzvXhzBzzVjyMMfWiP2gjm65tWMUknBrqhXzwv4"
// 		},
// 		{
// 			"name": "potato_cornor",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmQRyD4zq58WbYbufHmXkFzqctLni345worXhbkHcHKgfr"
// 		},
// 		{
// 			"name": "metro",
// 			"status": false,
// 			"img": "https://gateway.kumandra.org/files/QmaJX93zWqmCgHBmc1utvp3ZqN6Zw9JAVZxJA27mrwjzYL"
// 		},
// 		{
// 			"name": "amazon",
// 			"status": false,
// 			"img": "https://gateway.kumandra.org/files/QmSgKZS78RrspFz1tpok1rL5vxaeJNfC4M2thZoYL8bXMT"
// 		},
// 		{
// 			"name": "cristal_chicken",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmPW5nAbuF7GR65Tsfxg8btpdDBwjS82irRCNVTpAzGfET"
// 		},
// 		{
// 			"name": "dek_cha",
// 			"status": false,
// 			"img": "https://gateway.kumandra.org/files/QmQ3ckcY44gDcuCShuikWn3vREWhSVyF71t9MAfmcKqjds"
// 		},
// 		{
// 			"name": "ten11_zando",
// 			"status": false,
// 			"img": "https://gateway.kumandra.org/files/Qmb3vGbfmRbqkVqpDyLrzuVt64HV1hYjMiprNbbDwLXDdw"
// 		}
// 	],
// 	"isGift": false,
// 	"createdAt": "2023-03-07T09:56:03.597Z",
// 	"updatedAt": "2023-03-07T16:45:40.909Z",
// 	"__v": 0,
// 	"id": "64070a335ec86b0c9f28cbdd"
// }), 200);

    // Response value = await GetRequest.claimBenefit("0xf78128b3687f05657C6c1E340ba14975253d8B66");

    print("value.body ${value.body}");

    print("value.statusCode ${value.statusCode}");

    if (value.statusCode == 200){

      decode = json.decode(value.body);

      benefits = Benefit().filter(List<Map<String, dynamic>>.from(decode!['claim_benefits']));

      tmpBenefits = Benefit().filter(List<Map<String, dynamic>>.from(decode!['claim_benefits']));

      // selectedItems =
      // print(benefits!.where((element) => element.status == true ? true : false).toList());

      // ignore: use_build_context_synchronously
      await showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (context){
          return StatefulBuilder(
            builder: (ctt, setstate){
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.black54,
                child: Stack(
                  children: [

                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: ListView.builder(
                        itemCount: benefits!.length,
                        itemBuilder: (context, index){
                          
                          return Container(
                            margin: EdgeInsets.only(
                              right: 5, left: 5,
                              top: index == 0 ? 20 : 5, 
                              bottom: index == ( benefits!.length -1 ) ? 100 : 5
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: benefits![index].status == true 
                              ? Color.fromARGB(255, 33, 33, 33)
                              : event_crew.AppUtil.convertHexaColor("#254294").withOpacity(tmpBenefits![index].status == true ? 1.0 : 0.2),
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: InkWell(
                            onTap: benefits![index].status == true ? null : (){


                              if (tmpBenefits![index].status == false){

                                selectedIndex.add({
                                  "index": index,
                                  "status": true
                                });
                              } else {

                                // ignore: list_remove_unrelated_type
                                List<Map<String, dynamic>> item = selectedIndex.where((element) => element['index'] == index ? true : false ).toList();
                                selectedIndex.remove(item[0]);
                              }
                              tmpBenefits![index].status = !tmpBenefits![index].status!;
                              setstate(() { });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                                children: [

                                  Image.network(tmpBenefits![index].img!, width: 40, height: 40,),
                                  MyText(
                                    left: 15,
                                    text: tmpBenefits![index].name.toString(), 
                                    fontWeight: FontWeight.w700, 
                                    color2: Colors.white,
                                    fontSize: 18,
                                  ),

                                  Expanded(child: Container()),
                                  benefits![index].status == true ? const Icon(Icons.check_rounded, color: Colors.green,) : Container()
                                ]
                              )
                            ),
                          );

                        }
                      )
                    ),

                    Positioned(
                      left: 10, right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: event_crew.AppUtil.convertHexaColor("#1a2d66")
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                    
                            TextButton(
                              onPressed: (){

                                selectedIndex.clear();

                                tmpBenefits = tmpBenefits!.map((e) {
                                  
                                  if (e.status == false){
                                    e.status = true;
                                    selectedIndex.add({
                                      "index": tmpBenefits!.indexOf(e),
                                      "status": true
                                    });
                                  }
                                  return e;
                                }).toList();
                                
                                print('selectedIndex $selectedIndex');

                                // for (int i = 0; i < tmpBenefits!.length; i++ ) {
                                //   selectedIndex.add({
                                //     "index": i,
                                //     "status": true
                                //   });
                                // }
                                //   return e;
                                // }).toList() as List<Map<String, dynamic>>;

                                setstate(() {});
                              }, 
                              child: const MyText(text: "ទាំងអស់", color2: Colors.white,)
                            ),
                            const SizedBox(width: 10,),

                            TextButton(
                              onPressed: (){
                                
                                // ignore: unnecessary_cast
                                selectedIndex.clear();
                                tmpBenefits = tmpBenefits!.map((e) {
                                  e.status = false;
                                  return e;
                                }).toList() ;

                                setstate(() {});
                              }, 
                              child: const MyText(text: "សារដើម", color2: Colors.white,)
                            ),
                            SizedBox(width: 10,),
                    
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5, right: 5),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                                  ),
                                  onPressed: () async {

                                    print("selectedIndex $selectedIndex");  
                                    // selectedIndex.clear();
                                    
                                    // for(var e in list!){
                                                        
                                    //   selectedIndex.add({
                                    //     "index": benefits!.indexOf(e),
                                    //     "status": false
                                    //   });
                                    // }
                                                        
                                    await submitUpdate(); 
                                  }, 
                                  child: MyText(top: 15, bottom: 15, text: "យល់ព្រម", color2: Colors.white,)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.red[900]  ,
                          child: Icon(
                            Icons.close_rounded, 
                            color: event_crew.AppUtil.convertHexaColor("#730202")
                          ),
                        ),
                      )
                    )
                  ],
                ),
              );
            }
          ); 
        }
      );
    } else {
      
      await DialogCom().errorMsgCustomButton(context, json.decode(value.body)['message']);
    }

  }

  Future<void> submitUpdate() async {

    print("selectedIndex $selectedIndex");

    if (selectedIndex.isEmpty){

      await DialogCom().errorMsgCustomButton(context, "មិនមានការកែប្រែ");
    } else {

      try {

        DialogCom().dialogLoading(context);

        await PostRequest.claimBenefits(decode!['_id'], selectedIndex).then((value) async {
          print("value ${value.body}");
          if (value.statusCode == 200 && json.decode(value.body)['message'].toString().toLowerCase() == "updated successfully!") {

            // Close Dialog
            // ignore: use_build_context_synchronously
            Navigator.pop(context);

            await event_crew.DialogCom().successMsg(
              context, json.decode(value.body)['message'],
              action2: Container(
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
              )
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
        
        await DialogCom().errorMsgCustomButton(context, e.toString());

      }
    }

  }

  @override
  void initState() {
    initCamera();

    // Future.delayed(Duration(seconds: 1), (){ claimingDialog(Response("", 200)); });
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
                  print("MobileScanner error $error");
                  return Container();//ScannerErrorWidget(error: error);
                },
                onDetect: (capture) async {
                  
                  DialogCom().dialogLoading(context);
                  await _controller.stop();

                  print("capture.barcodes.first.rawValue! ${capture.barcodes.first.rawValue!}");

                  // print("capture.barcodes.first.rawValue ${  }");

                  await GetRequest.claimBenefit( await (json.decode(capture.barcodes.first.rawValue!))['addr'] ).then((value) async {
                    
                    // Close Dialog
                    Navigator.pop(context);

                    // print("value ${value.body}");
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