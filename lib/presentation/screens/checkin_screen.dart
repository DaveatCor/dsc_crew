

import 'package:mdw_crew/domain/usecase/check_in_uc/check_in_uc_impl.dart';
import 'package:mdw_crew/index.dart';

class CheckInScreen extends StatelessWidget {

  final PageController? pageController;

  const CheckInScreen({super.key, this.pageController});

  @override
  Widget build(BuildContext context) {

    final CheckInUcImpl checkInUcImpl = CheckInUcImpl();

    checkInUcImpl.setBuildContext = context;

    checkInUcImpl.initState();
    
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
                    onPressed: checkInUcImpl.updateData, 
                    icon: const Icon(Icons.restore_rounded)
                  )
                ],
              ),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    checkInUcImpl.matches != null ? ListView.builder(
                      itemCount: checkInUcImpl.matches!.value.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        
                        return EventCardCom(
                          func: () async {

                            Navigator.push(
                              context, 
                              Transition(child: QrScanner(title: 'ស្កេនសំបុត្រ', func: checkInUcImpl.admissioinFunc, hallId: '', isBackBtn: true,), transitionEffect: TransitionEffect.RIGHT_TO_LEFT)
                            );

                          },
                          title: checkInUcImpl.matches!.value[index]['title'],
                          qty: provider.tga.checkIn.toString(),
                          img: 'Premium2.png',
                          matchInfo: checkInUcImpl.matches!.value[index]
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