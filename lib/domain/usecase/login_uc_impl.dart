import 'package:mdw_crew/index.dart';

class LoginUcImpl implements LoginUseCase {

  BuildContext? context;

  final LoginModel loginModel = LoginModel();
  
  ReceivePort port = ReceivePort();

  set setContext(BuildContext ctx) {
    context = ctx;
  }

  @override
  initState(){
    loginModel.email.text = "crew@gmail.com";
    loginModel.pwd.text = "domreychey168@@";
  }
  
  @override
  Future<void> cacheCheck() async {
    
    await StorageServices.fetchData(dotenv.get('REGISTRAION')).then((value) async {

      DialogCom().dialogLoading(context!);
 
      if (value != null){

         Navigator.pushAndRemoveUntil(
          context!, 
          Transition(child: const Home()), 
          (route) => false
        );

      } else {

        // Close Dialog
        Navigator.pop(context!);
      }

    });

  }

  @override
  void changeShow(bool? value){

    loginModel.isShow = value;
  }

  @override
  void onChanged(int? index) async {

    DialogCom().dialogLoading(context!);
    
  }

  @override
  String onSubmit(String value){
    submitLogin();
    return '';
  }

  @override
  Future<void> submitLogin() async {

    DialogCom().dialogLoading(context!);

    print("submitLogin");

    try {
      
      await PostRequest.login(loginModel.email.text, loginModel.pwd.text).then((value) async {

        print("login value ${value.body}");
        
        loginModel.decode = await json.decode(value.body);

        if (  !(loginModel.decode!.containsKey('token')) ){

          Vibration.hasVibrator().then((value) async {

            if (value == true) {
              await Vibration.vibrate(duration: 90);
            }
          });

          // Close Dialog
          Navigator.pop(context!);
          
          // ignore: use_build_context_synchronously
          await DialogCom().dialogMessage(
            context!, 
            title: Lottie.asset(
              "assets/animation/failed.json",
              repeat: true,
              reverse: true,
              height: 80
            ), 
            content: MyText(text:  loginModel.decode!['message'], fontWeight: FontWeight.w500, left: 10, right: 10,)
          );

        }
        // Successfully Login
        else if (loginModel.decode!.containsKey('token')) {

          print("loginModel.decode!.containsKey('token') ${loginModel.decode!.containsKey('token')}");
          await GetRequest().queryDSCJSON();
          await StorageServices.storeData((await json.decode(value.body))['token'], dotenv.get('REGISTRAION'));

          // ignore: use_build_context_synchronously
          await Navigator.pushAndRemoveUntil(
            context!,
            Transition(child: const Home()),
            (route) => false
          );
        }
        
      });
    } catch (e) {
      
      Vibration.hasVibrator().then((value) async {

        if (value == true) {
          await Vibration.vibrate(duration: 90);
        }
      });

      // Close Dialog
      Navigator.pop(context!);

      DialogCom().dialogMessage(
        context!, 
        title: Lottie.asset(
          "assets/animation/failed.json",
          repeat: true,
          reverse: true,
          height: 80
        ),
        content: MyText(text: "Something wrong $e",
        fontWeight: FontWeight.w500, left: 10, right: 10,)
      );

      if (kDebugMode){
        print("submitLogin failed");
      }

    }
  }

  
}