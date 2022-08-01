
 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/timer_controller.dart';
import 'package:gameplugin/src/models/timer_action.dart';
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

  Timer? timer;
  late int deftime;
  late int time;
  final List<StreamSubscription> _streamSubscriptions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deftime = widget.time;
    time = widget.time;

    _streamSubscriptions.add(TimerController.instance.stream.listen((TimerAction action) {
      if(action==TimerAction.restart){
        time=deftime;
        createTimer();
      }
      if(action==TimerAction.pause){
        timer?.cancel();
      }
      if(action==TimerAction.play){
        createTimer();
      }
    }));
    createTimer();
  }

  createTimer(){
    timer?.cancel();
    TimerController.instance.timeUp=false;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(time<=0){
        TimerController.instance.timeUp=true;
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
    timer?.cancel();
    for(StreamSubscription streamSubscription in _streamSubscriptions) {
      streamSubscription.cancel();
    }
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
