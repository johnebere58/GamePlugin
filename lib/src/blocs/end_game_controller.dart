
import 'dart:async';
import 'package:gameplugin/src/blocs/timer_controller.dart';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndGameController {

  static EndGameController get instance => getIt<EndGameController>();

  final StreamController<ScoreModel> _streamController = StreamController.broadcast();

  Stream<ScoreModel> get stream => _streamController.stream;

  int _passed = 0;
  int _failed = 0;
  int _rounds = 0;

  int get rounds => _rounds;

  void increasePassed(){
    _passed++;
    _rounds++;
  }
  void increaseFailed(){
    _failed++;
    _rounds++;
  }

  void endGame(){
    _streamController.add(ScoreModel(totalFailed: _failed,totalPassed: _passed,scoreReady: true));
    TimerController.instance.pause();
  }

  void resetScore(){
    _passed = 0;
    _failed = 0;
    _rounds = 0;
  }

 }