
import 'dart:async';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/models/timer_action.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';

class TimerController {

  static TimerController get instance => getIt<TimerController>();

  final StreamController<TimerAction> _streamController = StreamController.broadcast();

  Stream<TimerAction> get stream => _streamController.stream;

  bool timeUp = false;

  void resetTimer(){
    _streamController.add(TimerAction.restart);
  }
  void pause(){
    _streamController.add(TimerAction.pause);
  }
  void resume(){
    _streamController.add(TimerAction.play);
  }

 }