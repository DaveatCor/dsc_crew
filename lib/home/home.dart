import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:event_crew/event_crew.dart' as evtCrew;
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:mdw_crew/backend/post_api.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/home/pages/checkin.dart';
import 'package:mdw_crew/home/pages/general/general.dart';
import 'package:mdw_crew/home/pages/membership/membership.dart';
import 'package:mdw_crew/home/pages/movie/bloc_movie.dart';
import 'package:mdw_crew/model/benefit_m.dart';
import 'package:mdw_crew/registration/login.dart';
import 'package:mdw_crew/service/storage.dart';
import 'package:transition/transition.dart';

import '../components/dialog_c.dart';

class Home extends StatefulWidget {
  
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final PageController controller = PageController();

  evtCrew.HomeModel model = evtCrew.HomeModel();
  
  int? active = 0; 

  @override
  void initState() {

    model.itemsList = [
      {'asset': 'packages/event_crew/assets/icons/admission.png', 'name': 'ការប្រកួត'},
      {'asset': 'assets/icons/membership.png', 'name': "កាតសមាជិក"},
      {"asset": "assets/icons/movie.png", "name": "ទូទៅ",},
      {'asset': 'packages/event_crew/assets/icons/logout.png', 'name': 'ចាកចេញ'}
    ];
    controller.addListener(() {
      setState(() {
        
        active = controller.page!.toInt();
      });
    });
    super.initState();
  }

  Future<void> logoutMsg() async {
    await DialogCom().dialogMessage(
      context, 
      title: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: SizedBox(
          width: 30,
          child: Lottie.asset(
            "assets/animation/exit.json",
            repeat: true,
            reverse: true,
            height: 100
          ),
        ),
      ), 
      edgeInsetsGeometry: const EdgeInsets.all(20),
      content: AnimatedTextKit(
        repeatForever: true,
        pause: const Duration(seconds: 1),
        animatedTexts: [

          TypewriterAnimatedText(
            "Are you sure wanna log out?",
            textAlign: TextAlign.center,
            textStyle: const TextStyle(
              fontSize: 14
            )
          ),

        ],
      ),
      // MyText(text: "Are you sure wanna sign out?",),
      action2: TextButton(
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all(Colors.red),
        //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
        // ),
        onPressed: () async {

          DialogCom().dialogLoading(context, content: "Signing Out");
          await saveCacheApi();
                          
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context, 
            Transition(child: const LoginPage(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT), 
            (route) => false
          );
          
        },
        child: const MyText(text: "Yes", left: 10, right: 10, color2: Colors.red, fontSize: 12, fontWeight: FontWeight.bold,),
      ),
    );
  }

  Future<void> saveCacheApi() async {

    await StorageServices.fetchData("dsc_api").then((value) async {
      print("saveCacheApi value $value");
      await StorageServices.clearStorage();

      print("value['api'] ${value['api']}");
      await StorageServices.storeApiFromGithub(value);
    });
  }

  Color? color = Colors.green.withOpacity(0.3);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: evtCrew.AppUtil.convertHexaColor("#F2F2F2"),
      body: SafeArea(
        child: PageView(
          controller: controller,
          onPageChanged: (value) {
            setState(() {
              active = controller.page!.toInt();

              if (controller.page!.toInt() == 0){
                color = Colors.blue.withOpacity(0.3);
              } else if ((controller.page!.toInt() == 1)){
                color = Colors.red.withOpacity(0.3);
              }
            });
          },
          children: [
            // Check(tabType: 'Check',),
            CheckIn(),
            const Membership(),
            const General()
            // const CheckOut(),
          ],
        ),
      ),
      // bottomNavigationBar: bottomAppBar(context: context, controller: controller, active: active)
      bottomNavigationBar: evtCrew.bottomAppBarNoCheck(
        context: context, 
        controller: controller, 
        itemsList: model.itemsList,
        active: active,
        onTap: (value) async {

          if (value == 0){

            controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
            active = controller.page!.toInt();

            color = Colors.blue.withOpacity(0.3);
            setState(() { });
          } else if (value == 1){

            controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
            active = controller.page!.toInt();
            
            color = Colors.red.withOpacity(0.3);
            setState(() { });

          } else if (value == 2){

            controller.animateToPage(value, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
            active = controller.page!.toInt();
            
            color = Colors.red.withOpacity(0.3);
            setState(() { });

          }
          else if (value == model.itemsList.length -1 ) {

            await logoutMsg();

            // await DialogCom().dialogLoading(context, content: "Signing Out");
            //   await StorageServices.clearStorage();
                              
            //   // ignore: use_build_context_synchronously
            //   Navigator.pushAndRemoveUntil(
            //     context, 
            //     Transition(child: const LoginPage(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT), 
            //     (route) => false
            //   );
          }

        }
      )
    );
  }
}
