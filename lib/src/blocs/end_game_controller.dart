
import 'dart:async';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';

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

  void endGame() {
    _streamController.add(ScoreModel(totalFailed: _failed,totalPassed: _passed));
  }

  void resetScore(){
    _passed = 0;
    _failed = 0;
    _rounds = 0;
  }

 }