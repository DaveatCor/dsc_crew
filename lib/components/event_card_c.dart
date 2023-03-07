import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mdw_crew/components/text_c.dart';

class EventCardCom extends StatelessWidget {

  final String? img;
  final String? title;
  final String? qty;
  final Map<String, dynamic>? matchInfo;
  final Function()? func;
  
  const EventCardCom({
    super.key, 
    this.qty,
    this.matchInfo,
    required this.img,
    required this.title,
    required this.func
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func!,
      child: Column(
        children: [

          MyText(text: title, fontSize: 20, bottom: 20, fontWeight: FontWeight.w600,),

          SizedBox(
            height: 230,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Image.asset("assets/imgs/$img", fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: 230,),

                  Container(
                    height: 230,
                    color: Colors.black.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        MyText(text: matchInfo!['match_date'], fontSize: 18, fontWeight: FontWeight.bold, color2: Colors.white,),
                        
                        // AnimatedTextKit(
                        //   repeatForever: true,
                        //   pause: const Duration(seconds: 1),
                        //   animatedTexts: [

                        //     TypewriterAnimatedText(
                        //       ,
                        //       textAlign: TextAlign.center,
                        //       textStyle: const TextStyle(
                        //         fontWeight: FontWeight.bold, 
                        //         color: Colors.white, 
                        //         fontSize: 18
                        //       ),
                        //     ),

                        //   ],
                        // ),

                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.network(matchInfo!['first']),
                                          
                                    MyText(top: 10, text: matchInfo!['first_club_name'], fontWeight: FontWeight.bold, color2: Colors.white,)
                                  ],
                                )
                              ),
                                          
                              Expanded(
                                child: Column(
                                  children: [
                                    
                                    const MyText(text: 'KICK-OFF', fontWeight: FontWeight.bold, color2: Colors.white, fontSize: 22,),

                                    SizedBox(
                                      height: 50,
                                      child: AnimatedTextKit(
                                        repeatForever: true,
                                        pause: const Duration(seconds: 1),
                                        animatedTexts: [

                                          FadeAnimatedText(
                                            matchInfo!['kick_off_time'],
                                            textAlign: TextAlign.center,
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold, 
                                              color: Colors.white, 
                                              fontSize: 18,
                                            ),
                                          ),

                                        ],
                                      )  ,
                                    ) 
                                    // MyText(text: '15:45', fontWeight: FontWeight.bold, color2: Colors.white, fontSize: 22)
                                  ],
                                )
                              ),
                              
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.network(matchInfo!['second']),
                                          
                                    MyText(top: 10, text: matchInfo!['second_club_name'], fontWeight: FontWeight.bold, color2: Colors.white)
                                  ],
                                )
                              ),
                              
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      // Card(
      //   child: Stack(
      //     children: [

      //       Container(
      //         height: 150,
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(20),
      //           child: Image.asset("assets/mdw/$img", fit: BoxFit.cover, width: MediaQuery.of(context).size.width,),
      //         ),
      //       ),
      //       // Container(
      //       //   height: 200,
      //       //   width: MediaQuery.of(context).size.width,
      //       //   child: MyText(
      //       //     height: double.maxFinite,
      //       //     text: "The Greatest Artist",
      //       //   ),
      //       // ),
      //     ],
      //   ),
      // ),
    );
  }
}