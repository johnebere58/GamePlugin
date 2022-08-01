
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/models/game_mode.dart';

extension GameIdExtension on GameIds{

  String get title =>
      index == GameIds.find_ball_game.index?"Find Ball" :
      index == GameIds.find_bug_game.index?"Find Bug" :
      "";


  String get description =>
      index == GameIds.find_ball_game.index?
      "Find the ball with the color as the balls are hidden and shuffled around" :
      index == GameIds.find_bug_game.index?
      "Find the hidden bug, as the balls are shuffled around" :
      "";



}