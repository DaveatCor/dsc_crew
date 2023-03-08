import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_installer/app_installer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:lottie/lottie.dart';
import 'package:mdw_crew/backend/post_api.dart';
import 'package:mdw_crew/components/dialog_c.dart';
import 'package:mdw_crew/components/event_card_c.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/provider/mdw_socket_p.dart';
import 'package:mdw_crew/qr_scanner/qr_scanner.dart';
import 'package:mdw_crew/service/storage.dart';
import 'package:mdw_crew/tool/sound.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:vibration/vibration.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../backend/get_api.dart';
import 'package:event_crew/event_crew.dart' as evtCrew;


class CheckIn extends StatefulWidget {

  final PageController? pageController;
  final String? tabType;

  CheckIn({super.key, this.pageController, required this.tabType});

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {

  List<Map<String, dynamic>>? matches;

  double iconSize = 35;

  bool? _isSuccess = false;

  @override
  initState(){
    queryMatch();
    super.initState();
  }

  void queryMatch() async {

    matches = List<Map<String, dynamic>>.from( (await StorageServices.fetchData('matches'))['matches']);

    setState(() { });
  }

  Future<bool> admissioinFunc(String eventId, String data) async {
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
          await evtCrew.DialogCom().errorMsg(
            context,
            json.decode(value.body)['message'],
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

        }
        
      });

      return _isSuccess!;

    } catch (er) {

      SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

      await evtCrew.DialogCom().errorMsg(
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DSCSocketProvider>(
      builder: (context, provider, widgets) {
        return Container(
          color: Colors.blue.withOpacity(0.15),
          padding: const EdgeInsets.all(20),
          child: Column(
        
            children: [

              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 80,
                  child: AnimatedTextKit(
                    // pause: Duration(milliseconds: 300),
                    repeatForever: true,
                    animatedTexts: [
                      
                      TypewriterAnimatedText(
                        'ស្កេនសំបុត្រ', 
                        textStyle: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold, ),
                        
                      ),
                      // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
                    ],
                    onTap: () {
                    },
                  ),
                )
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    matches != null ? ListView.builder(
                      itemCount: matches!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        
                        return EventCardCom(
                          func: () async {

                            Navigator.push(
                              context, 
                              Transition(child: QrScanner(title: '${widget.tabType}', func: admissioinFunc, hallId: 'tga',), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                            );

                          },
                          title: matches![index]['title'],
                          qty: provider.tga.checkIn.toString(),
                          img: 'Premium2.png',
                          matchInfo: matches![index]
                        );
                      }
                    ) : Container(),

                  ],
                ),
              )
        
            ],
          ),
        );
      }
    );
  }
}