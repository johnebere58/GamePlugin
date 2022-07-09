import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gameplugin/src/blocs/pop_single_text_controller.dart';
import 'package:gameplugin/src/settings/text_data.dart';
import 'package:gameplugin/src/utils/screen_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

class PopTextWidget extends StatefulWidget {
  const PopTextWidget({Key? key}):super(key:key);
   @override
   _PopTextWidgetState createState() => _PopTextWidgetState();
 }

 class _PopTextWidgetState extends State<PopTextWidget> {

   final List<StreamSubscription> _streamSubscriptions = [];
   TextData? _textData;
  @override
  void initState() {
    _streamSubscriptions.add(
        PopSingleTextController.
        instance.stream.listen((event) {
          _textData = event;
          if(mounted)setState(() {});
          Future.delayed(const Duration(seconds: 1),(){
            _textData = null;
            if(mounted)setState(() {});
          });
        }));

    super.initState();
  }

   @override
   void dispose() {
     for(StreamSubscription stream in _streamSubscriptions) {
       stream.cancel();
     }
     super.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return page();
   }

   Widget page(){

     return AnimatedPositioned(
       duration: const Duration(milliseconds: 500),
       top: _textData!=null?60:-60,
       left: (getScreenWidth(context)/2 -150),
       child: SizedBox(width: 300,height: 100,
       child: _textData==null?Container():Text(_textData!.text,
           style: textStyle(true, 40, _textData!.textColor,withShadow: true,),textAlign: TextAlign.center),
     ),
     );
   }
 }
