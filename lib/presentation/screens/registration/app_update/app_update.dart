import 'package:mdw_crew/index.dart';

class AppUpdate extends StatefulWidget {

  final String? appVer;

  const AppUpdate({super.key, this.appVer});

  @override
  State<AppUpdate> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdate> {

  AppUpdateProvider? _updateProvider;

  Directory? appDocDir;

  @override
  void initState() {

    _updateProvider = Provider.of<AppUpdateProvider>(context, listen: false);

    // _updateProvider!.registerIsolation(context, installApps);

    statusChecker();

    checkUpdate();

    super.initState();
  }

  @override
  void dispose() {
    // IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void statusChecker() async {
    await SecureStorage.readSecure(dotenv.get("DOWNLOAD_STATUS"))!.then((value) {
      if (value.isNotEmpty){
        if (value == DLStatus.DOWNLOADING.toString()){
          _updateProvider!.isUpdate = true;
        } else if (value == DLStatus.DOWNLOADED.toString()){
          _updateProvider!.isUpdate = false;
          _updateProvider!.progress = 100;
        } else if (value == DLStatus.DOWNLOADED.toString()){
          _updateProvider!.isUpdate = false;
          _updateProvider!.progress = 0;
        }
      }
    });

    setState(() {
      _updateProvider!.msg = [
        "Apps v${widget.appVer} is up to date",
        "New version available ${_updateProvider!.newVer}"
      ];
    });
  }

  Future<void> checkUpdate() async {

    // Query and Get Data From Local Storage
    await SecureStorage.readSecure('dsc_api')!.then((value) async {
      if (value.isEmpty){
        
        if (json.decode(value)['app_version'] != "v${widget.appVer}"){
          
          _updateProvider!.newVer = json.decode(value)['app_version'];

          _updateProvider!.msg[1] = "New version available ${_updateProvider!.newVer}";

          _updateProvider!.isAvailale = true;

          setState(() { });
          // await _downloadApk();

        } else {

          // await DialogCom().dialogMessage(context, content: MyText(text: "Your apps v${(await PackageInfo.fromPlatform()).version} is up to date",));

          
        }
      }
    });
    
  }

  Future<void> _downloadApk() async {

    var url = "https://github.com/selendra/dsc_crew/releases/download/${_updateProvider!.newVer}/dsc_crew_${_updateProvider!.newVer}.apk";

    // Dio dio = Dio();

    try {
      await launchUrl( Uri.parse(url), mode: LaunchMode.externalApplication);
      // if (await canLaunchUrl(Uri.parse(url))){

      // }
      // var dir = await getApplicationDocumentsDirectory();
      // print("Download complete. statusCode: ${response.statusCode}");
    } catch (e) {

      await DialogCom().dialogMessage(
        context, 
        title: Lottie.asset(
          "assets/animation/failed.json",
          repeat: true,
          reverse: true,
          height: 80
        ), 
        content: MyText(text: e.toString(), fontWeight: FontWeight.w500, left: 10, right: 10,)
      );
    }

    // FlutterDownloader.registerCallback( AppUpdateProvider.downloadCallback );
    
    // try{
    //   await Permission.storage.request().then((storage) async {
    //     print("storage.isGranted ${storage.isGranted}");
        
    //     if (storage.isGranted){

    //       appDocDir = await getExternalStorageDirectory();
    //       String appDocPath = appDocDir!.path;

    //       // var url = "https://github.com/selendra/dsc_crew/releases/tag/v1.0.2";
          
    //       // await submitLogin();
    //       // final taskId = await FlutterDownloader.enqueue(
    //       //   url: 'https://github.com/selendra/dsc_crew/releases/download/${_updateProvider!.newVer}/dsc_crew_${_updateProvider!.newVer}.apk',
    //       //   headers: {}, // optional: header send with url (auth token etc)
    //       //   savedDir: appDocPath,
    //       //   fileName: "dsc_crew_${_updateProvider!.newVer}.apk",
    //       //   showNotification: true, // show download progress in status bar (for Android)
    //       //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    //       //   saveInPublicStorage: true
    //       // );

    //       // setState(() {
    //       //   _updateProvider!.isUpdate = true;
    //       // });

    //       await StorageServices.storeData(DLStatus.DOWNLOADING.toString(), dotenv.get('DOWNLOAD_STATUS'));
    //     }
    //   });

    // } catch (e) {
    //   print("Error FlutterDownloader $e");
    // }
  }

  // Future<void> installApps() async {

  //   IsolateNameServer.removePortNameMapping('downloader_send_port');

  //   await Permission.storage.request().then((storage) async {
       
  //     if (storage.isGranted){
    
  //       appDocDir = await getExternalStorageDirectory();
  //       // if (appDocDir == null) {
  //       // }
  //       // String appDocPath = appDocDir!.path;
        
  //       if (appDocDir!.path.contains('apk')){

  //         await Permission.requestInstallPackages.request().then((value) async {
  //           if (value.isGranted){

  //             FileSystemEntity _apkPath = await appDocDir!.list().first;
  //             print(_apkPath.path);
  //             await AppInstaller.installApk(_apkPath.path); 

  //           }
  //         });

  //       } else {

  //         await StorageServices.storeData(DLStatus.DOWNLOAD.toString(), dotenv.get("DOWNLOAD_STATUS"));
  //         await StorageServices.fetchData(dotenv.get("DOWNLOAD_STATUS"));

  //       }
  //     }
  //   });

  // }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: 'Check Update'),
      ),
      body: Consumer<AppUpdateProvider>(
        builder: (context, provider, widget){
          return provider.msg.isNotEmpty ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // if (!provider.isUpdate)
                UpdateNow(isAvailable: provider.isAvailale, msg: provider.msg[ !provider.isAvailale ? 0 : 1], downloadFunc: _downloadApk),

                // if (provider.isUpdate && provider.progress != 100) 
                // DownloadProgress(percentage: provider.progress),

                // // if (provider.progress == 100 && provider.progress != -1)
                // InstallApp(newVer: provider.newVer!, installApps: installApps),

              ],
            ),
          ) : const Center(child: CircularProgressIndicator(),);
        }
      ),
    );
  }
}