

import 'package:mdw_crew/index.dart';

class InstallApp extends StatelessWidget {

  final String? newVer;
  final Function? installApps;

  const InstallApp({super.key, required this.newVer, required this.installApps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        MyText(
          text: "New version $newVer download completely",
          bottom: 30,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            onPressed: () async {

              // setState(() {
              //   prog = 50;
              // });
              
              await installApps!();
            }, 
            child: MyText(
              width: MediaQuery.of(context).size.width,
              top: 20,
              bottom: 20,
              fontWeight: FontWeight.w600,
              text: "Install",
            )
          ),
        )
      ],
    );
  }
}