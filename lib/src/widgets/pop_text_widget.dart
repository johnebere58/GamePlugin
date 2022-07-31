import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/blocs/pop_single_text_controller.dart';
import 'package:gameplugin/src/models/text_data.dart';
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

     // _textData = TextData(textColor: blue0, text: "Hello");
     return IgnorePointer(
       child: Stack(
         alignment: Alignment.center,
         children: [
       AnimatedOpacity(
       opacity: _textData!=null?1:0,duration: const Duration(milliseconds: 300),
         child: ClipRect(
             child:BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                 child: Container(
                   color: Colors.white.withOpacity(.5),
                 ))
         ),
       ),
           AnimatedOpacity(
             duration: const Duration(milliseconds: 500),
             opacity: 1,
             child: AnimatedScale(
               scale: _textData!=null?3:1,
               duration: const Duration(milliseconds: 500),
               alignment: Alignment.center,
               // (width: 50,height: 100,
             child: //_textData==null?Container():
             Text(_textData?.text ?? "",
                 style: textStyle(true, 15,
                   _textData?.textColor??white,
                 ),
                 textAlign: TextAlign.center),
           ),
           ),
         ],
       ),
     );
   }
 }
