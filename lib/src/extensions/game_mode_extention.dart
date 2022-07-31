
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/models/game_mode.dart';

extension GameModeExtension on GameMode{

  BallCount get getBallCount =>
      index==0? BallCount.two:
      index==1?BallCount.three:
      index==2?BallCount.four:
      BallCount.eight;

  double get passPercentage =>
      index==0? 85:
      index==1?75:
      index==2?65:
      50
  ;

  String get name =>
      index==0? "Easy":
      index==1?"Normal":
      index==2?"Hard":
      "Difficult"
  ;



  // int get gameTime =>
  //     index==0? 60:
  //     index==1? 90:
  //     index==2? 120:
  //     150;
  //
  // int get gameRounds =>
  //     gameTime~/5;

}