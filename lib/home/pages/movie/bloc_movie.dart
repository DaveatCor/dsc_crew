import 'dart:convert';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:mdw_crew/backend/get_api.dart';
import 'package:mdw_crew/backend/post_api.dart';
import 'package:mdw_crew/components/dialog_c.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/model/benefit_m.dart';
import 'package:mdw_crew/qr_scanner/qr_scanner.dart';
import 'package:mdw_crew/tool/sound.dart';
import 'package:event_crew/event_crew.dart' as event_crew;

class MovieTicket extends StatefulWidget {
  
  const MovieTicket({super.key});

  @override
  State<MovieTicket> createState() => _MovieTicketState();
}

class _MovieTicketState extends State<MovieTicket> {

  Map<String, dynamic>? decode;

  List<Benefit> selectedItems = [];

  List<Map<String, dynamic>> selectedIndex = [];

  List<Benefit>? benefits;

  List<Benefit>? tmpBenefits;

  List<Map<String, dynamic>>? matches;

  double iconSize = 35;

  bool? _isSuccess = false;

  // MobileScannerController _controller = MobileScannerController(autoStart: true);

  Future<bool> scanMovieQR(String data) async {

    print("scanMovieQR $data");

    _isSuccess = false;

    try {

      DialogCom().dialogLoading(context);

      try {

        // Scan Difference QR
        await PostRequest.scanMovieTicket(data).then((value) async {
          // dynamic value = Response(json.encode({"message":"Success!","seat":{"_id":"6478421520e6f969efcf5faf","row":"D","seatNumber":12}}), 200);
          print("value ${value.body}");
          print("value ${value.statusCode}");

          decode = json.decode(value.body);
          print("value.statusCode == 200 && decode!.containsKey('seat') ${value.statusCode == 200 && decode!.containsKey('seat')}");
          if (value.statusCode == 200 && decode!.containsKey('seat')){

            // ignore: use_build_context_synchronously
            Navigator.pop(context);

            await DialogCom().dialogMessage(
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
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
              
                    MyText(text: "ជួរកៅអី: ${decode!['seat']['row']}", bottom: 5, fontSize: 18, fontWeight: FontWeight.w700),
              
                    MyText(text: "លេខកៅអី: ${decode!['seat']['seatNumber']}", fontSize: 18, fontWeight: FontWeight.w700,),
                    
                  ],
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
              )
            );
          } else {

            print("Else ${decode!['message']}");

            SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

            // Close Dialog
            // ignore: use_build_context_synchronously
            Navigator.pop(context);

            // ignore: use_build_context_synchronously
            await DialogCom().errorMsgCustomButton(
              context, 
              decode!['message']
            );

            // await _controller.start();
          }
        });
      } catch (e) {

        SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

        // Close Dialog
        Navigator.pop(context);

        // ignore: use_build_context_synchronously
        await DialogCom().errorMsgCustomButton(
          context, 
          "Something wrong $e"
        );

        // await _controller.start();
      }

      return _isSuccess!;

    } catch (er) {

      SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

      await DialogCom().errorMsgCustomButton(
        context,
        'Something when wrong'
      );

      return _isSuccess!;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QrScanner(title: 'ស្កេនសំបុត្រកុន', func: scanMovieQR);
  }
}