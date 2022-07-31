
import 'dart:async';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';

class TimerController {

  static TimerController get instance => getIt<TimerController>();

  final StreamController<bool> _streamController = StreamController.broadcast();

  Stream<bool> get stream => _streamController.stream;

  void resetTimer(){
    _streamController.add(true);
  }

 }