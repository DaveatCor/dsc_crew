import 'package:mdw_crew/index.dart';
import 'package:event_crew/event_crew.dart' as evtCrew;

class HomeUcImpl implements HomeUsecase {

  BuildContext? context;

  final PageController controller = PageController();

  evtCrew.HomeModel model = evtCrew.HomeModel();
  
  ValueNotifier<int> active = ValueNotifier(0); 

  Color? color = Colors.green.withOpacity(0.3);

  set setBuildContext(BuildContext ctx){
    context = ctx;
  }

  @override
  void initState() {

    model.itemsList = [
      {'asset': 'packages/event_crew/assets/icons/admission.png', 'name': 'ការប្រកួត'},
      {'asset': 'assets/icons/membership.png', 'name': "កាតសមាជិក"},
      {"asset": "assets/icons/movie.png", "name": "ទូទៅ",},
      {'asset': 'packages/event_crew/assets/icons/logout.png', 'name': 'ចាកចេញ'}
    ];
    controller.addListener(() {
      active.value = controller.page!.toInt();
    });
    
  }

  void bottomOnChange(int index) async {
    if (index == 0){
      controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      active.value = controller.page!.toInt();

      color = Colors.blue.withOpacity(0.3);
    } else if (index == 1){

      controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      active.value = controller.page!.toInt();
      
      color = Colors.red.withOpacity(0.3);

    } else if (index == 2){

      controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOutExpo);
      active.value = controller.page!.toInt();
      
      color = Colors.red.withOpacity(0.3);

    }
    else if (index == model.itemsList.length -1 ) {

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

  @override
  Future<void> logoutMsg() async {
    await evtCrew.DialogCom().dialogMessage(
      context!, 
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

          evtCrew.DialogCom().dialogLoading(context!, content: "Signing Out");
          await saveCacheApi();
                          
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context!, 
            Transition(child: const LoginScreen(), transitionEffect: TransitionEffect.LEFT_TO_RIGHT), 
            (route) => false
          );
          
        },
        child: const MyText(text: "Yes", left: 10, right: 10, color2: Colors.red, fontSize: 12, fontWeight: FontWeight.bold,),
      ),
    );
  }

  @override
  Future<void> saveCacheApi() async {

    await SecureStorage.readSecure("dsc_api")!.then((index) async {

      await SecureStorage.clearAllSecure();

      await storeApiFromGithub(json.decode(index));
    });
  }

  Future<void> storeApiFromGithub(Map<String, dynamic> value) async {
    print("storeApiFromGithub value['api'] ${value['api']}");
    await SecureStorage.writeSecure(
      'dsc_api',
      json.encode({
        "api": value['api']
      }), 
    );
  }
  
}