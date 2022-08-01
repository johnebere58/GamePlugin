import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:animated_rotation/animated_rotation.dart' as anim;
import 'package:flutter/services.dart';
import 'package:gif_view/gif_view.dart';

class BugWidget extends StatefulWidget {

  const BugWidget({Key? key}) : super(key: key);

   @override
   _BugWidgetState createState() => _BugWidgetState();
 }

 class _BugWidgetState extends State<BugWidget> {

  Uint8List? gif;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadGif();
  }

  loadGif()async{
    final gdata = await rootBundle.load('packages/gameplugin/assets/images/bug.gif');
    gif = gdata.buffer.asUint8List(gdata.offsetInBytes, gdata.lengthInBytes);
    if(mounted)setState(() {});
  }

   @override
   Widget build(BuildContext context) {
     return gif==null?Container():GifView.memory(
       gif!,
       width: 30,height: 30,);
   }
 }
