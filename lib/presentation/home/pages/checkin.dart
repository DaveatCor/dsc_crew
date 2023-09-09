
import 'package:event_crew/event_crew.dart' as evtCrew;
import 'package:mdw_crew/index.dart';

class CheckIn extends StatefulWidget {

  final PageController? pageController;

  CheckIn({super.key, this.pageController});

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

  Future<bool> admissioinFunc(String data) async {
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
              // ignore: use_build_context_synchronously
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
            action2: SizedBox(
              // ignore: use_build_context_synchronously
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
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
        'Something when wrong',
        action2: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            onPressed: (){
              Navigator.pop(context);
            },
            child: const MyText(text: "បិទ", top: 20, bottom: 20, color2: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        )
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

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            'បញ្ជីការប្រកួត', 
                            textStyle: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold, ),
                            
                          ),
                          // MyText(text: widget.hallId == 'vga' ? provider.vga.checkIn.toString() : provider.tga.checkIn.toString(), color2: Colors.green, right: 10, fontWeight: FontWeight.bold, fontSize: 17,);
                        ],
                        onTap: () {
                        },
                      ),
                    )
                  ),
                  
                  const Expanded(child: SizedBox()),

                  IconButton(
                    onPressed: () async {

                      DialogCom().dialogLoading(context);

                      await GetRequest.fetchMatchData().then((value) async {
                        Map<String, dynamic> jsn = json.decode(value.body);
                        print("Value ${value.body}");
                        matches![0] = {
                          "title": "${jsn['league']['name']} | ${jsn['week']} | AIA Stadium KMH Park",
                          "first": jsn["home_team_logo"],
                          "first_club_name": jsn['home_team_name'], 
                          "second": jsn["away_team_logo"],
                          "second_club_name": jsn["away_team_name"],
                          "match_date": jsn['date'],
                          "kick_off_time": jsn['ko']
                        };

                        await StorageServices.storeData(
                          {
                            "matches": matches!
                          }, 
                          'matches'
                        );
                        Navigator.pop(context);
                        setState(() {});
                      });
                    }, 
                    icon: const Icon(Icons.restore_rounded)
                  )
                ],
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
                              Transition(child: QrScanner(title: 'ស្កេនសំបុត្រ', func: admissioinFunc, hallId: '', isBackBtn: true,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
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