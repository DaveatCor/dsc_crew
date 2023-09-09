import 'package:mdw_crew/index.dart';

class GeneralUcImpl implements GeneralUsecase {

  BuildContext? context;

  Map<String, dynamic>? decode;

  List<Benefit> selectedItems = [];

  List<Map<String, dynamic>> selectedIndex = [];

  List<Benefit>? benefits;

  List<Benefit>? tmpBenefits;

  List<Map<String, dynamic>>? generals;

  double iconSize = 35;

  ValueNotifier<bool> isSuccess = ValueNotifier(false);

  @override
  set setBuildContext(BuildContext ctx) {
    context = ctx;
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
  }


  Future<bool> scanAddrQR(String id) async {

    print("scanMovieQR $id");

    isSuccess.value = false;

    try {

      DialogCom().dialogLoading(context!);

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
            Navigator.pop(context!);

            await DialogCom().dialogMessage(
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
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(text: decode!['message'], bottom: 5, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              action: Container(
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
              )
            );
          } else {

            print("Else ${decode!['message']}");

            SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

            // Close Dialog
            // ignore: use_build_context_synchronously
            Navigator.pop(context!);

            // ignore: use_build_context_synchronously
            await DialogCom().errorMsgCustomButton(
              context!, 
              decode!['message']
            );

            // await _controller.start();
          }
        });

      } catch (e) {

        SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

        // Close Dialog
        Navigator.pop(context!);

        // ignore: use_build_context_synchronously
        await DialogCom().errorMsgCustomButton(
          context!, 
          "Something wrong $e"
        );

        // await _controller.start();
      }

      return isSuccess.value;

    } catch (er) {

      SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

      await DialogCom().errorMsgCustomButton(
        context!,
        'Something when wrong'
      );

      return isSuccess.value;
    }
  }

}