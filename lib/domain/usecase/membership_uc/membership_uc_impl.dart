import 'package:mdw_crew/index.dart';
import 'package:event_crew/event_crew.dart' as event_crew;
// ignore: depend_on_referenced_packages
import 'package:http/http.dart';

class MembershipUcImpl implements MembershipUsecase {

  BuildContext? context;

  Map<String, dynamic>? decode;

  List<Benefit> selectedItems = [];

  List<Map<String, dynamic>> selectedIndex = [];

  List<Benefit>? benefits;

  List<Benefit>? tmpBenefits;

  List<Map<String, dynamic>>? matches;

  double iconSize = 35;

  bool? _isSuccess = false;

  set setBuildContext(BuildContext ctx){
    context = ctx;
  }

  // MobileScannerController _controller = MobileScannerController(autoStart: true);

//   Map staticData = {
// 	"isGift": false,
// 	"_id": "63e4f4b0394b1df6219e1775",
// 	"userId": "63e4e3fc394b1df6219e1501",
// 	"membershipPackageId": "63db392708c7e10fced41afe",
// 	"claim_benefits": [
// 		{
// 			"name": "metro",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/QmaJX93zWqmCgHBmc1utvp3ZqN6Zw9JAVZxJA27mrwjzYL"
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
// 			"name": "ten11_zando",
// 			"status": true,
// 			"img": "https://gateway.kumandra.org/files/Qmb3vGbfmRbqkVqpDyLrzuVt64HV1hYjMiprNbbDwLXDdw"
// 		},
// 		{
// 			"name": "jersey",
// 			"status": false,
// 			"image": "jersey.png"
// 		}
// 	],
// 	"no": "999997",
// 	"createdAt": "2023-02-09T13:27:12.103Z",
// 	"updatedAt": "2023-08-04T02:16:06.554Z",
// 	"__v": 0,
// 	"cardImage": "0xD9708c09E95e710dbeDE6f3A467d67818BA45b43.png",
// 	"id": "63e4f4b0394b1df6219e1775"
// };

  Future<bool> redeem(String data) async {

    _isSuccess = false;

    try {

      DialogCom().dialogLoading(context!);

      try {

        decode = json.decode(data);

        // Scan Difference QR
        if (decode!.containsKey('type') && decode!.containsKey('addr')){

          // print("capture.barcodes.first.rawValue ${  }");

          await GetRequest.claimBenefit(decode!['addr']).then((value) async {
            
            // Close Dialog
            Navigator.pop(context!);

            // print("value ${value.body}");
            await claimingDialog(value);
            
          });
        } else {

          SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

          // Close Dialog
          // ignore: use_build_context_synchronously
          Navigator.pop(context!);

          // ignore: use_build_context_synchronously
          await DialogCom().errorMsgCustomButton(
            context!, 
            "QR របស់កាតសមាជិកមិនត្រឹមត្រូវ"
          );

          // await _controller.start();
        }
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

      return _isSuccess!;

    } catch (er) {

      SoundUtil.soundAndVibrate('mixkit-tech-break-fail-2947.wav');

      await DialogCom().errorMsgCustomButton(
        context!,
        'Something when wrong'
      );

      return _isSuccess!;
    }
  }

  Future<void> claimingDialog(Response value) async {

    if (value.statusCode == 200){

      decode = json.decode(value.body);

      benefits = Benefit().filter(List<Map<String, dynamic>>.from(decode!['claim_benefits']));

      tmpBenefits = Benefit().filter(List<Map<String, dynamic>>.from(decode!['claim_benefits']));

      // ignore: use_build_context_synchronously
      await showDialog(
        barrierDismissible: false,
        context: context!, 
        barrierColor: Colors.black26,
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
                      height: MediaQuery.of(context!).size.height / 1.8,
                      child: ListView.builder(
                        itemCount: benefits!.length,
                        itemBuilder: (context, index){
                          
                          return Container(
                            margin: EdgeInsets.only(
                              right: 5, left: 5,
                              top: index == 0 ? 20 : 5, 
                              bottom: index == ( benefits!.length -1 ) ? 100 : 5
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                            decoration: BoxDecoration(
                              color: benefits![index].status == true 
                              ? const Color.fromARGB(255, 59, 59, 59).withOpacity(0.5)
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

                                  // Image.network(tmpBenefits![index].img!, width: 40, height: 40,),
                                  MyText(
                                    left: 15,
                                    text: tmpBenefits![index].name.toString(), 
                                    fontWeight: FontWeight.w700, 
                                    color2: benefits![index].status == false ? Colors.white : Colors.black87,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Expanded(
                              child: ElevatedButton(
                                // style: ButtonStyle(
                                //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                                // ),
                                onPressed: () async {
                                                      
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
                            
                                  setstate(() {});
                                }, 
                                child: const MyText(top: 15, bottom: 15, text: "ទាំងអស់", color2: Colors.white,)
                              ),
                            ),
                            
                            SizedBox(width: 10,),

                            // Expanded(
                            //   child: ElevatedButton(
                            //     // style: ButtonStyle(
                            //     //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                            //     // ),
                            //     onPressed: selectedIndex.isEmpty ? null : () async {
                                  
                            //       // ignore: unnecessary_cast
                            //       selectedIndex.clear();
                            //       tmpBenefits!.map((e) {
                            //         if (benefits![benefits!.indexOf(e)].status != true){
                            //           e.status = false;
                            //         }
                            //         return e;
                            //       }).toList() ;

                            //       setstate(() {});
                            //     }, 
                            //     child: const MyText(top: 15, bottom: 15, text: "សារដើម", color2: Colors.white,)
                            //   ),
                            // ),

                            // TextButton(
                            //   onPressed: (){
                                
                            //     // ignore: unnecessary_cast
                            //     selectedIndex.clear();
                            //     tmpBenefits = tmpBenefits!.map((e) {
                            //       if (benefits![benefits!.indexOf(e)].status != true){
                            //         e.status = false;
                            //       }
                            //       return e;
                            //     }).toList() ;

                            //     setstate(() {});
                            //   }, 
                            //   child: const MyText(text: "សារដើម", color2: Colors.white,)
                            // ),
                            // SizedBox(width: 10,),
                    
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                child: ElevatedButton(
                                  // style: ButtonStyle(
                                  //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))
                                  // ),
                                  onPressed: () async {
                                                        
                                    await submitUpdate(); 

                                    SoundUtil.soundAndVibrate('mixkit-confirmation-tone-2867.wav');
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
                          Navigator.pop(context!);
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
      
      await DialogCom().errorMsgCustomButton(context!, json.decode(value.body)['message']);
    }

  }

  Future<void> submitUpdate() async {

    if (selectedIndex.isEmpty){

      await DialogCom().errorMsgCustomButton(context!, "មិនមានការកែប្រែ");
    } else {

      try {

        DialogCom().dialogLoading(context!);

        await PostRequest.claimBenefits(decode!['_id'], selectedIndex).then((value) async {
          print("value ${value.body}");
          if (value.statusCode == 200 && json.decode(value.body)['message'].toString().toLowerCase() == "updated successfully!") {

            // Close Dialog
            // ignore: use_build_context_synchronously
            Navigator.pop(context!);

            await event_crew.DialogCom().successMsg(
              context!, json.decode(value.body)['message'],
              action2: Container(
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

            // ignore: use_build_context_synchronously
            Navigator.pop(context!);
          } else {
            
            throw Exception(json.decode(value.body));
          }
        });


      } catch (e) {

        // Close Dialog
        // ignore: use_build_context_synchronously
        Navigator.pop(context!);
        
        await DialogCom().errorMsgCustomButton(context!, e.toString());

      }
    }

  }
  
}