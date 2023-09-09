
import 'package:mdw_crew/index.dart';

class GeneralScreen extends StatelessWidget {
  
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final GeneralUcImpl generalUcImpl = GeneralUcImpl();

    generalUcImpl.setBuildContext = context;
    
    generalUcImpl.initState();

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
              //           generalUcImpl.generals![0] = {
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
                    
                    generalUcImpl.generals != null ? ListView.builder(
                      itemCount: generalUcImpl.generals!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        
                        return InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => QrScanner(
                                title: generalUcImpl.generals![index]['title'], 
                                func: generalUcImpl.scanAddrQR
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
                                      Text(generalUcImpl.generals![index]['title']),
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
                        //   title: generalUcImpl.generals![index]['title'],
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