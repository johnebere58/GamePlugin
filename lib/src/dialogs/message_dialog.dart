import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gameplugin/src/utils/screen_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

class MessageDialog extends StatefulWidget {
  final icon;
  final Color iconColor;
  final String title;
  final String message;
  final String yesText;
  final String? noText;
  final bool cancellable;
  final double iconPadding;

  const MessageDialog(
      this.icon, this.iconColor, this.title, this.message, this.yesText,
      {this.noText,
        this.cancellable = false,
        this.iconPadding = 0,Key? key}):super(key: key);
  @override
  _MessageDialogState createState() => _MessageDialogState();
}

class _MessageDialogState extends State<MessageDialog> {

  bool showBack=false;
  bool hideUI=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 200),(){
      hideUI=false;
      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 500),(){
      showBack=true;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.cancellable) closePage((){ Navigator.pop(context);});

        return Future.value(false);
      },
      child: Stack(fit: StackFit.expand, children: <Widget>[
        GestureDetector(
          onTap: () {
            if (widget.cancellable) closePage((){ Navigator.pop(context);});
          },
          child: AnimatedOpacity(
            opacity: showBack?1:0,duration: const Duration(milliseconds: 300),
            child: ClipRect(
                child:BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: Colors.black.withOpacity(.7),
                    ))
            ),
          ),
        ),
        page()
      ]),
    );
  }

  Widget page() {
    var icon = widget.icon;
    String message = widget.message;
    Color iconColor = widget.iconColor;
    String title = widget.title;
    return AnimatedOpacity(
      opacity: hideUI?0:1,duration: const Duration(milliseconds: 400),
      child: Center(
        child: Container(
          margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
          // constraints: BoxConstraints(
          //   maxWidth: getScreenWidth(context)>500?500
          //       :double.infinity,
          //   minWidth: getScreenWidth(context)/2
          // ),
          width: getScreenWidth(context)>500?500:getScreenWidth(context),
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white, elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
//              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.fromLTRB(20,20,20,15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: EdgeInsets.all(
                              widget.iconPadding ?? 0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: (icon is String)
                              ? (Image.asset(
                            icon,
                            color: iconColor,
                            width: 45,
                            height: 45,
                          ))
                              : Icon(
                            icon,
                            color: iconColor,
                            size: 45,
                          )),
                      addSpace(20),
                      Text(
                        title,
                        style: textStyle(true, 20, Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      if(message.isNotEmpty)addSpace(4),
                      if(message.isNotEmpty)Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            "$message",
                            style: textStyle(false, 16, Colors.black.withOpacity(.5)),
                            textAlign: TextAlign.center,
//                                    maxLines: 1,
                          ),
                        ),
                      ),
                      if(message.isNotEmpty)addSpace(10),
                    ],
                  ),
                ),

                addLine(1, Colors.black.withOpacity(.1), 0, 0, 0, 0),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10,0,10,20),
                  child: Wrap(
                    // mainAxisSize: MainAxisSize.min,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Container(
//                              height: 50,
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: FlatButton(
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            // color: blue0,
                            onPressed: () {
                              closePage(() async {
                                Navigator.pop(context,true);
                              });
                            },
                            child: Text(
                              // "OK",
                              widget.yesText,
                              maxLines: 1,
                              style: textStyle(true, 18, Colors.blueAccent),
                            )),
                      ),
                      if(widget.noText!=null)Container(
                        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0)
                            ),
                            onPressed: () {
                              closePage(()async{
                                Navigator.pop(context,false);});
                            },
                            child: Text(
                              widget.noText!,maxLines: 1,
                              style: textStyle(true, 18, Colors.red),
                            )),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void closePage(onClosed){
    showBack=false;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 300),(){
      Future.delayed(const Duration(milliseconds: 100),(){
        hideUI=true;
        setState(() {});
      });
      onClosed();
    });
  }
}

