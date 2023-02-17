import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/qr_scanner/qr_scanner.dart';
import 'package:transition/transition.dart';

class EventCardCom extends StatelessWidget {

  final String? img;
  final String? title;
  final String? qty;
  final Function()? func;
  
  const EventCardCom({
    super.key, 
    required this.img,
    required this.title,
    this.qty,
    required this.func
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: func!,
      child: Column(
        children: [

          MyText(text: title, fontSize: 20, bottom: 20, fontWeight: FontWeight.w600,),

          // qty != null ? Container(
          //   child: Row(
          //     children: [
                
          //       MyText(text: "Quantity: $qty", bottom: 10, fontSize: 13,),
          //     ],
          //   ),
          // ) : Container(),

          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [

                  Image.asset("assets/imgs/$img", fit: BoxFit.cover, width: MediaQuery.of(context).size.width,),

                  Container(
                    height: 220,
                    color: Colors.black.withOpacity(0.5),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        
                        AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(seconds: 1),
                          animatedTexts: [

                            TypewriterAnimatedText(
                              "18/Feb/2023",
                              textAlign: TextAlign.center,
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold, 
                                color: Colors.white, 
                                fontSize: 18
                              ),
                            ),

                          ],
                        ),
                        // MyText(text: "18/Feb/2023", fontWeight: FontWeight.bold, color2: Colors.white, fontSize: 22, bottom: 10,),
                  
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Row(
                            children: [
                              
                              Expanded(
                                child: Column(
                                  children: [
                                    Image.asset('assets/logos/isi-dsc-logo.png'),
                                          
                                    MyText(text: 'ISI DANGKOR SENCHEY FC', fontWeight: FontWeight.bold, color2: Colors.white,)
                                  ],
                                )
                              ),
                                          
                              Expanded(
                                child: Column(
                                  children: [
                                    MyText(text: 'KICK-OFF', fontWeight: FontWeight.bold, color2: Colors.white, fontSize: 22,),

                                    Container(
                                      height: 50,
                                      child: AnimatedTextKit(
                                        repeatForever: true,
                                        pause: const Duration(seconds: 1),
                                        animatedTexts: [

                                          FadeAnimatedText(
                                            "15:45",
                                            textAlign: TextAlign.center,
                                            textStyle: TextStyle(
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
                                    Image.asset('assets/logos/naga.png'),
                                          
                                    MyText(text: 'NAGA WORLD FC', fontWeight: FontWeight.bold, color2: Colors.white)
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