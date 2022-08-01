
import 'dart:async';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/blocs/timer_controller.dart';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameSettingsController {

  static GameSettingsController get instance => getIt<GameSettingsController>();

  final StreamController<GameSettings> _streamController = StreamController.broadcast();

  Stream<GameSettings> get stream => _streamController.stream;

  void updateSettings(GameSettings gameSettings){
    _streamController.add(gameSettings);
  }
 }