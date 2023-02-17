import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mdw_crew/components/text_c.dart';
import 'package:mdw_crew/tool/app_utils.dart';

class DialogCom {
  
  dialogMessage(
    BuildContext context, 
    {Widget? title, 
    Widget? content, 
    Widget? action,
    Widget? action2,
    EdgeInsetsGeometry? edgeInsetsGeometry
  }
  ) {

    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {

        return AlertDialog(
          title: title ?? Container(),
          // titlePadding: const EdgeInsets.all(20),
          titlePadding: edgeInsetsGeometry,
          content: content ?? Container(),
          contentPadding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            
            action ?? TextButton(
              // style: ButtonStyle(
              //   backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
              //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
              // ),
              onPressed: (){
                Navigator.pop(context);
              },
              child: const MyText(text: "Close", color2: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
            ),

            action2 ?? Container()
          ],
        );
        // WillPopScope(
        //   onWillPop: () => Future(() => false),
        //   child: ,
        // );
      }
    );
  }

  dialogMessageNoClose(
    BuildContext context, 
    {Widget? title, 
    Widget? content, 
    Widget? action,
    Widget? action2,
    EdgeInsetsGeometry? edgeInsetsGeometry
  }
  ) {

    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {

        return WillPopScope(
          onWillPop: () => Future(() => false),
          child: AlertDialog(
            title: title ?? Container(),
            // titlePadding: const EdgeInsets.all(20),
            titlePadding: edgeInsetsGeometry,
            content: content ?? Container(),
            contentPadding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            actions: [
              
              action ?? TextButton(
                // style: ButtonStyle(
                //   backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
                //   shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                // ),
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const MyText(top: 5, bottom: 5, text: "Close", left: 10, right: 10, color2: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),
              ),

              action2 ?? Container()
            ],
          )
        );
      }
    );
  }

  dialogLoading(BuildContext context, {bool? isTicket = false, String? content}) {

    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: _progress(isTicket: isTicket!, content: content)
        );
        // WillPopScope(
        //   onWillPop: () => Future(() => false),
        //   child: ,
        // );
      }
    );
  }

  Widget _progress({bool isTicket = false, String? content}) {
  return Material(
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(
                AppUtil.convertHexaColor("#34B768")
              )
            ),

            if (content == null)
            Container()
            else
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 16.0),
              child: MyText(
                text: content, 
                color2: Colors.black,
              ),
            ),
          ],
        )
      ],
    ),
  );
}
}