import 'dart:ui';

import 'package:mdw_crew/index.dart';

class AppUpdateProvider with ChangeNotifier {

  int progress = 0;

  bool isAvailale = false;
  bool isUpdate = false;

  List<String> msg = [];

  String? newVer;

  // void registerIsolation(BuildContext context, Function? installApps) async {

  //   IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
  //     _port.listen((dynamic data) async {
  //       print("listen _port $data");
  //       String id = data[0];
  //       DownloadTaskStatus status = data[1];
  //       print("status.value ${status.value}");
  //       if (status.value == 4){
  //         await DialogCom().dialogMessage(
  //           context, 
  //           title: MyText(text: "Oops",), 
  //           content: MyText(text: "It seem you already install"), 
  //           action2: TextButton(
  //             onPressed: () async {
  //               await installApps!();
  //             }, 
  //             child: MyText(text: "Install now",)
  //           )
  //         );
  //       }

  //       if (data[2] != -1) {
  //         progress = data[2];

  //         if (progress == 100){
  //           await StorageServices.storeData(DLStatus.DOWNLOADED.toString(), dotenv.get("DOWNLOAD_STATUS"));
  //         }
          
  //       }

  //       notifyListeners();
        
  //     });
  // }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
    
  }
}