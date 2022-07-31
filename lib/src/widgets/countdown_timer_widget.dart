
 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

class CountDownTimerWidget extends StatefulWidget {
  final int time;
  final Function onComplete;
  const CountDownTimerWidget({required this.time,
    required this.onComplete,Key? key}) : super(key: key);

   @override
   State<CountDownTimerWidget> createState() => _CountDownTimerWidgetState();
 }

 class _CountDownTimerWidgetState extends State<CountDownTimerWidget> {

  late Timer timer;
  late int time;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    time = widget.time;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(time<=0){
        widget.onComplete();
        timer.cancel();
        return;
      }
      time--;
      if(mounted)setState((){});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

   @override
   Widget build(BuildContext context) {
     return Text(getTimerText(time),style: textStyle(true, 20, black),);
   }

   String getTimerText(int seconds, {bool three = false}) {
     int hour = seconds ~/ Duration.secondsPerHour;
     int min = (seconds ~/ 60) % 60;
     int sec = seconds % 60;

     String h = hour.toString();
     String m = min.toString();
     String s = sec.toString();

     String hs = h.length == 1 ? "0$h" : h;
     String ms = m.length == 1 ? "0$m" : m;
     String ss = s.length == 1 ? "0$s" : s;

     return three ? "$hs:$ms:$ss" : "$ms:$ss";
   }
 }
