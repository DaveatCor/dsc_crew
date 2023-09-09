import 'package:mdw_crew/index.dart';

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
      await SecureStorage.writeSecure(
        'dsc_api',
        json.encode({
          "api": (await json.decode(value.body))["api"]
        }), 
      );

      if ((await json.decode(value.body))["api_test"] != null){

        await SecureStorage.writeSecure(
          'dsc_api_test',
          json.encode({
            "api_test": (await json.decode(value.body))["api_test"]
          }), 
        );
      }

      /// Query Match Data
      await SecureStorage.writeSecure(
        'matches',
        json.encode({
          "matches": (await json.decode(value.body))['matches']
        }), 
      );
      
      // Query Admin Account
      await SecureStorage.writeSecure(
        'admin_acc',
        json.encode({
          "admin_acc": (await json.decode(value.body))['admin_acc']
        }), 
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
      home: const LoginScreen(),
    );
  }
}