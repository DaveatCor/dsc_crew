import 'package:mdw_crew/index.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final LoginUcImpl loginUcImpl = LoginUcImpl();

    loginUcImpl.setContext = context;

    loginUcImpl.initState();

    loginUcImpl.cacheCheck();

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Stack(
              children: [

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, top: 15),
                    height: 30,
                    child: DropdownButton(
                      underline: Container(),
                      icon: const Icon(Icons.settings),
                      items: const [

                        // DropdownMenuItem(
                        //   value: 0,
                        //   child: MyText(text: "អាប់ឌែតការប្រកួត",),
                        // ),
                         
                        DropdownMenuItem(
                          value: 1,
                          child: MyText(text: "Reload cache",),
                        )
                      ],
                      onChanged: loginUcImpl.onChanged,
                    ),
                  )
                  
                ),
          
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Image.asset("assets/logos/isi-dsc-logo.png", width: 120,),
                    ),
                    
                    const MyText(
                      text: "LOGIN WITH YOUR EMAIL",
                      bottom: 30,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    
                    MyInputField(
                      labelText: "Email",
                      controller: loginUcImpl.loginModel.email, 
                      focusNode: loginUcImpl.loginModel.emailNode,
                      onSubmit: loginUcImpl.onSubmit,
                      pBottom: 20,
                    ),
                    
                    MyInputField(
                      labelText: "Password",
                      controller: loginUcImpl.loginModel.pwd, 
                      focusNode: loginUcImpl.loginModel.pwdlNode,
                      onSubmit: loginUcImpl.submitLogin,
                      pBottom: 30,
                      obcureText: !(loginUcImpl.loginModel.isShow!),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        onPressed: (){
                          loginUcImpl.changeShow(!(loginUcImpl.loginModel.isShow!));
                        },
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
                        ),
                        onPressed: () async {

                          await loginUcImpl.submitLogin();
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