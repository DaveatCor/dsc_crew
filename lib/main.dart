import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:mdw_crew/backend/get_api.dart';
import 'package:mdw_crew/provider/download_p.dart';
import 'package:mdw_crew/provider/mdw_socket_p.dart';
import 'package:mdw_crew/registration/login.dart';
import 'package:mdw_crew/service/storage.dart';
import 'package:mdw_crew/tool/app_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {

  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp ]);

  // await FlutterDownloader.initialize(
  //   debug: true, // optional: set to false to disable printing logs to console (default: true)
  //   ignoreSsl: true // option: set to false to disable working with http links (default: false)
  // );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MDWSocketProvider>(create: (context) => MDWSocketProvider()),
        ChangeNotifierProvider<AppUpdateProvider>(create: (context) => AppUpdateProvider())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {

    // FlutterDownloader.registerCallback( AppUpdateProvider.downloadCallback );

    GetRequest.querydscApiJson().then((value) async {
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

      // Initialize Socket
      // Provider.of<MDWSocketProvider>(context, listen: false).initSocket(json.decode(value.body)['ws']);
    });

    super.initState();
  }
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSC Crew',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('kh'), // Spanish
      ],
      theme: ThemeData(
        primaryColor: AppUtil.convertHexaColor("#254294"),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppUtil.convertHexaColor("#254294")))),
        fontFamily: "Barlow",
        appBarTheme: AppBarTheme(
          backgroundColor: AppUtil.convertHexaColor("#254294"),
        ),
        bottomAppBarTheme: BottomAppBarTheme(
          color: AppUtil.convertHexaColor("#254294")
        )
      ),
      home: const LoginPage(),
    );
  }
}