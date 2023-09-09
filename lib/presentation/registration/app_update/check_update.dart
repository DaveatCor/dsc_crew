

import 'package:mdw_crew/index.dart';

class UpdateNow extends StatelessWidget {

  final String? msg;
  final bool? isAvailable;
  final Function? downloadFunc;

  const UpdateNow({super.key, required this.isAvailable, required this.msg, required this.downloadFunc});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
        //   child: LinearPercentIndicator(
        //     // width: MediaQuery.of(context).size.width / 1.5,
        //     lineHeight: 14.0,
        //     percent: percent! / 100,
        //     center: Text(
        //       "${percent}",
        //       style: new TextStyle(fontSize: 12.0),
        //     ),
        //     linearStrokeCap: LinearStrokeCap.roundAll,
        //     backgroundColor: Colors.grey,
        //     progressColor: Colors.blue,
        //   ),
        // ),

        MyText(text: msg, bottom: 30,),

        isAvailable! ? Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
            ),
            onPressed: () async {
        
              downloadFunc!();
            }, 
            child: MyText(
              width: MediaQuery.of(context).size.width,
              top: 20,
              bottom: 20,
              fontWeight: FontWeight.w600,
              text: "Update Now",
            )
          ),
        ) : Container()
      ],
    );
  }
}