
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/models/game_mode.dart';
import 'package:gameplugin/src/extensions/ball_count_extention.dart';

extension GameModeExtension on GameMode{

  BallCount get getBallCount =>
      index==0? BallCount.two:
      index==1?BallCount.three:
      index==2?BallCount.four:
      BallCount.eight;


}