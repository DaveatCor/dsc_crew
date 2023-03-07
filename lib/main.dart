import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mdw_crew/backend/get_api.dart';
import 'package:mdw_crew/provider/download_p.dart';
import 'package:mdw_crew/provider/mdw_socket_p.dart';
import 'package:mdw_crew/registration/login.dart';
import 'package:mdw_crew/service/storage.dart';
import 'package:mdw_crew/tool/app_utils.dart';
import 'package:provider/provider.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter_downloader/flutter_downloader.dart';
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
        ChangeNotifierProvider<DSCSocketProvider>(create: (context) => DSCSocketProvider()),
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
      
      // Query API from Github Host
      await StorageServices.storeData(
        {
          "api": (await json.decode(value.body))["api"]
        }, 
        'dsc_api'
      );

      if ((await json.decode(value.body))["api_test"] != null){

        await StorageServices.storeData(
          {
            "api_test": (await json.decode(value.body))["api_test"]
          }, 
          'dsc_api_test'
        );
      }

      /// Query Match Data
      await StorageServices.storeData(
        {
          "matches": (await json.decode(value.body))['matches']
        }, 
        'matches'
      );
      
      // Query Admin Account
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
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