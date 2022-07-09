import 'package:gameplugin/src/settings/ball_count.dart';
import 'package:gameplugin/src/settings/game_speed.dart';

import 'ball_shape.dart';

class GameSettings{

    /// This is to set the size, color and  shape of the ball

    final BallCount ballCount;
    final GameSpeed gameSpeed;
    final BallShape ballShape;
    final double ballSize;

    GameSettings({required this.ballCount, required this.gameSpeed,required this.ballShape,this.ballSize=50.0});
 }