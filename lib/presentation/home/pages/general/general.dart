
import 'package:event_crew/event_crew.dart' as event_crew;
import 'package:mdw_crew/index.dart';

class General extends StatefulWidget {
  
  const General({super.key});

  @override
  State<General> createState() => _GeneralState();
}

class _GeneralState extends State<General> {

  Map<String, dynamic>? decode;

  List<Benefit> selectedItems = [];

  List<Map<String, dynamic>> selectedIndex = [];

  List<Benefit>? benefits;

  List<Benefit>? tmpBenefits;

  List<Map<String, dynamic>>? generals;

  double iconSize = 35;

  bool? _isSuccess = false;

  // MobileScannerController _controller = MobileScannerController(autoStart: true);

  Future<bool> scanAddrQR(String id) async {

    print("scanMovieQR $id");

    _isSuccess = false;

    try {

      DialogCom().dialogLoading(context);

      try {

        // Scan Difference QR
        await PostRequest.userAsset(id).then((value) async {
          // dynamic value = Response(json.encode({"message":"Success!","seat":{"_id":"6478421520e6f969efcf5faf","row":"D","seatNumber":12}}), 200);
          
          // Response value = Response(
          //   json.encode({
          //     "status": true,
          //     "message": "The user already claimed."
          //   }),
          //   400
          // );

          print("value ${value.body}");
          print("value ${value.statusCode}");

          decode = json.decode(value.body);
          print("value.statusCode == 200 && decode!.containsKey('seat') ${value.statusCode == 200 && decode!.containsKey('seat')}");
          if (value.statusCode == 200){

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
                child: MyText(text: decode!['message'], bottom: 5, fontSize: 18, fontWeight: FontWeight.w700),
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
    generals = [
      {
        "type": "Merchant",
        "title": "Fan Jersey",
        "image": "https://backend.dangkorsenchey.com/public/images/1692870498477.png"
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue.withOpacity(0.15),
          padding: const EdgeInsets.all(20),
          child: Column(
        
            children: [

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [

              //     Align(
              //       alignment: Alignment.topLeft,
              //       child: SizedBox(
              //         height: 80,
              //         child: AnimatedTextKit(
              //           // pause: Duration(milliseconds: 300),
              //           repeatForever: true,
              //           animatedTexts: [
                          
              //             TypewriterAnimatedText(
              //               'បញ្ជីការប្រកួត', 
              //               textStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold, ),
                            
              //             ),
              //             // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
              //           ],
              //           onTap: () {
              //           },
              //         ),
              //       )
              //     ),
                  
              //     const Expanded(child: SizedBox()),

              //     IconButton(
              //       onPressed: () async {

              //         DialogCom().dialogLoading(context);

              //         await GetRequest.fetchMatchData().then((value) async {
              //           Map<String, dynamic> jsn = json.decode(value.body);
              //           print("Value ${value.body}");
              //           generals![0] = {
              //             "title": "${jsn['league']['name']} | ${jsn['week']} | AIA Stadium KMH Park",
              //             "first": jsn["home_team_logo"],
              //             "first_club_name": jsn['home_team_name'], 
              //             "second": jsn["away_team_logo"],
              //             "second_club_name": jsn["away_team_name"],
              //             "match_date": jsn['date'],
              //             "kick_off_time": jsn['ko']
              //           };

              //           await StorageServices.storeData(
              //             {
              //               "matches": matches!
              //             }, 
              //             'matches'
              //           );
              //           Navigator.pop(context);
              //           setState(() {});
              //         });
              //       }, 
              //       icon: const Icon(Icons.restore_rounded)
              //     )
              //   ],
              // ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    generals != null ? ListView.builder(
                      itemCount: generals!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        
                        return InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QrScanner(
                                title: generals![index]['title'], 
                                func: scanAddrQR
                              ))
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Banner(
                              message: 'Claim',
                              location: BannerLocation.topEnd,
                              color: Colors.blue,
                              textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              child: Card(
                                margin: EdgeInsets.zero,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6 ),
                                        child: Image.network("https://backend.dangkorsenchey.com/public/images/1692870498477.png", width: 80,),
                                      ),
                                      Text(generals![index]['title']),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                        // EventCardCom(
                        //   func: () async {

                        //     // Navigator.push(
                        //     //   context, 
                        //     //   Transition(child: QrScanner(title: 'ស្កេនសំបុត្រ', func: admissioinFunc, hallId: '', isBackBtn: true,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                        //     // );

                        //   },
                        //   title: generals![index]['title'],
                        //   qty: "",
                        //   img: 'Premium2.png',
                        //   matchInfo: matches![index]
                        // );
                      }
                    ) : Container(),

                  ],
                ),
              )
        
            ],
          ),
        ),
    );
    // QrScanner(title: 'ស្កេនសំបុត្រកុន', func: scanAddrQR)
  }
}