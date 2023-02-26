import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:app_installer/app_installer.dart';
import 'package:lottie/lottie.dart';
import 'package:mdw_crew/auth/google_login_a.dart';
import 'package:mdw_crew/backend/get_api.dart';
import 'package:mdw_crew/backend/post_api.dart';
import 'package:mdw_crew/components/dialog_c.dart';
import 'package:mdw_crew/components/input_field_c.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/home/home.dart';
import 'package:mdw_crew/model/login_m.dart';
import 'package:mdw_crew/provider/download_p.dart';
import 'package:mdw_crew/registration/app_update/app_update.dart';
import 'package:mdw_crew/service/storage.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:transition/transition.dart';
import 'package:vibration/vibration.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:package_info_plus/package_info_plus.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginModel _loginModel = LoginModel();
  
  ReceivePort _port = ReceivePort();

  String? version;

  @override
  void initState() {

    cacheCheck();

    _loginModel.email.text = "crew@gmail.com";
    _loginModel.pwd.text = "domreychey168@@";

    _queryAcc();

    super.initState();
  }

  void _queryAcc() async {

    await StorageServices.fetchData("admin_acc").then((value) {

      if (value != null){

        if (value['admin_acc'].containsKey("email") && value['admin_acc'].containsKey("password") ){
          
          _loginModel.email.text = value['admin_acc']['email'];
          _loginModel.pwd.text = value['admin_acc']['password'];
        } else {
          _loginModel.email.clear();
          _loginModel.pwd.clear();
        }
        if (mounted) setState(() { });
      }
    });
  }

  String onSubmit(String value){
    submitLogin();
    return '';
  }

  void cacheCheck() async {
    
    await StorageServices.fetchData(dotenv.get('REGISTRAION')).then((value) async {

      DialogCom().dialogLoading(context);
 
      if (value != null){

         Navigator.pushAndRemoveUntil(
          context, 
          Transition(child: const Home()), 
          (route) => false
        );

      } else {

        // Close Dialog
        Navigator.pop(context);
      }

    });

  }

  Future<void> submitLogin() async {

    DialogCom().dialogLoading(context);

    try {
      
      await PostRequest.login(_loginModel.email.text, _loginModel.pwd.text).then((value) async {

        print("login value ${value.body}");
        
        _loginModel.decode = await json.decode(value.body);

        if (  !(_loginModel.decode!.containsKey('token')) ){

          Vibration.hasVibrator().then((value) async {

            if (value == true) {
              await Vibration.vibrate(duration: 90);
            }
          });

          // Close Dialog
          Navigator.pop(context);
          
          await DialogCom().dialogMessage(
            context, 
            title: Lottie.asset(
              "assets/animation/failed.json",
              repeat: true,
              reverse: true,
              height: 80
            ), 
            content: MyText(text:  _loginModel.decode!['message'], fontWeight: FontWeight.w500, left: 10, right: 10,)
          );

        }
        // Successfully Login
        else if (_loginModel.decode!.containsKey('token')) {

          print("_loginModel.decode!.containsKey('token') ${_loginModel.decode!.containsKey('token')}");
          await queryDSCJSON();
          await StorageServices.storeData((await json.decode(value.body))['token'], dotenv.get('REGISTRAION'));

          await Navigator.pushAndRemoveUntil(
            context,
            Transition(child: Home()),
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
      Navigator.pop(context);

      DialogCom().dialogMessage(
        context, 
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
  
  Future<void> queryDSCJSON() async {

    await GetRequest.querydscApiJson().then((value) async {
      print("querydscApiJson");
      print("value ${value.body}");
      await StorageServices.storeData(
        {
          "LOGIN_API": (await json.decode(value.body))['LOGIN_API']
        }, 
        'dsc_api'
      );

      await StorageServices.storeData(
        {
          "matches": (await json.decode(value.body))['matches']
        }, 
        'matches'
      );

      await StorageServices.storeData(
        {
          "admin_acc": (await json.decode(value.body))['admin_acc']
        }, 
        'admin_acc'
      );

      // Initialize Socket
      // Provider.of<MDWSocketProvider>(context, listen: false).initSocket(json.decode(value.body)['ws']);
    });
  }

  void changeShow(bool? value){

    setState(() {
      _loginModel.isShow = value;
    });
  }

  void onChanged(int? index) async {

    DialogCom().dialogLoading(context);
    
    if (index == 0){

      // version = (await PackageInfo.fromPlatform()).version;

      // // Close Dialog Loading
      // Navigator.pop(context);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AppUpdate(appVer: version))
      // );
      
    } else {


      await GetRequest.querydscApiJson().then((value) async {
        print("querydscApiJson");
        print("value $value");
        await StorageServices.storeData(
          {
            "LOGIN_API": (await json.decode(value.body))['LOGIN_API']
          }, 
          'dsc_api'
        );

        await StorageServices.storeData(
          {
            "admin_acc": (await json.decode(value.body))['admin_acc']
          }, 
          'admin_acc'
        );
        _queryAcc();

        // Close Dialog Loading
        Navigator.pop(context);

        MotionToast.success(
          animationType: AnimationType.fromLeft,
          position: MotionToastPosition.top,
          description:  MyText(text: "Reload completed"),
          width:  250,
          height:  70,
          animationDuration: Duration(milliseconds: 700),
        ).show(context);

        // Initialize Socket
        // Provider.of<MDWSocketProvider>(context, listen: false).initSocket(json.decode(value.body)['ws']);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Stack(
              children: [

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.only(right: 20, top: 15),
                    height: 30,
                    child: DropdownButton(
                      underline: Container(),
                      icon: Icon(Icons.settings),
                      items: [

                        DropdownMenuItem(
                          child: MyText(text: "Check update",),
                          value: 0,
                        ),
                         
                        DropdownMenuItem(
                          child: MyText(text: "Reload cache",),
                          value: 1,
                        )
                      ],
                      onChanged: onChanged,
                    ),
                  )
                  
                ),
          
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Image.asset("assets/logos/isi-dsc-logo.png", width: 120,),
                    ),
                    
                    MyText(
                      text: "LOGIN WITH YOUR EMAIL",
                      bottom: 30,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    
                    MyInputField(
                      labelText: "Email",
                      controller: _loginModel.email, 
                      focusNode: _loginModel.emailNode,
                      onSubmit: onSubmit,
                      pBottom: 20,
                    ),
                    
                    MyInputField(
                      labelText: "Password",
                      controller: _loginModel.pwd, 
                      focusNode: _loginModel.pwdlNode,
                      onSubmit: submitLogin,
                      pBottom: 30,
                      obcureText: !(_loginModel.isShow!),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.remove_red_eye_outlined),
                        onPressed: (){
                          changeShow(!(_loginModel.isShow!));
                        },
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
                        ),
                        onPressed: () async {

                          await submitLogin();
                        }, 
                        child: MyText(
                          width: MediaQuery.of(context).size.width,
                          top: 20,
                          bottom: 20,
                          fontWeight: FontWeight.w600,
                          text: "LOGIN",
                        )
                      ),
                    ),
          
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}