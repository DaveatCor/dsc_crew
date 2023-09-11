import 'package:mdw_crew/index.dart';
// ignore: library_prefixes
import 'package:event_crew/event_crew.dart' as evtCrew;

class CheckInUcImpl implements CheckInUsecase {

  BuildContext? context;

  ValueNotifier<List<Map<String, dynamic>>>? matches = ValueNotifier([]);

  double iconSize = 35;

  bool? _isSuccess = false;

  set setBuildContext(BuildContext ctx) {
    context = ctx;
  }

  @override
  void initState(){
    queryMatch();
  }

  @override
  Future<void> queryMatch() async {
    print("queryMatch");
    matches!.value = List<Map<String, dynamic>>.from( json.decode(await SecureStorage.readSecure('matches')!)['matches']);
    print("matches!.value ${matches!.value}");
    matches!.notifyListeners();
  }

  Future<bool> admissioinFunc(String data) async {
    _isSuccess = false;

    try {

      await PostRequest.addmissionFunc(qrcodeData: data).then((value) async {

        if ( ((await json.decode(value.body))['status']).toString().toUpperCase() == 'SUCCESS'){

          _isSuccess = false;

          SoundUtil.soundAndVibrate('mixkit-confirmation-tone-2867.wav');

          // Provider.of<MDWSocketProvider>(context!, listen: false).emitSocket('check-in', {'hallId': "vga"});

          // ignore: use_build_context_synchronously
          await DialogCom().dialogMessageNoClose(
            context!,
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
              width: MediaQuery.of(context!).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                onPressed: (){
                  Navigator.pop(context!);
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
            context!,
            json.decode(value.body)['message'],
            action2: SizedBox(
              // ignore: use_build_context_synchronously
              width: MediaQuery.of(context!).size.width,
              child: ElevatedButton(
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
                  shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                onPressed: (){
                  Navigator.pop(context!);
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
        context!,
        'Something when wrong',
        action2: SizedBox(
          width: MediaQuery.of(context!).size.width,
          child: ElevatedButton(
            style: ButtonStyle(
              // backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            onPressed: (){
              Navigator.pop(context!);
            },
            child: const MyText(text: "បិទ", top: 20, bottom: 20, color2: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        )
      );

      return _isSuccess!;
    }
  }

  Future<void> updateData() async {

    DialogCom().dialogLoading(context!);
    await GetRequest.fetchMatchData().then((value) async {
      Map<String, dynamic> jsn = json.decode(value.body);
      print("Value ${value.body}");
      matches!.value[0] = {
        "title": "${jsn['league']['name']} | ${jsn['week']} | AIA Stadium KMH Park",
        "first": jsn["home_team_logo"],
        "first_club_name": jsn['home_team_name'], 
        "second": jsn["away_team_logo"],
        "second_club_name": jsn["away_team_name"],
        "match_date": jsn['date'],
        "kick_off_time": jsn['ko']
      };

      await SecureStorage.writeSecure(
        'matches',
        json.encode({
          "matches": matches!
        }), 
      );
      Navigator.pop(context!);
      
    });

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    matches!.notifyListeners();

  }
}