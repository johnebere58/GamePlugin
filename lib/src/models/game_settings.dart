import 'package:gameplugin/src/models/game_mode.dart';

import 'ball_shape.dart';

class GameSettings{

    /// This is to set the size, color and  shape of the ball

    // final BallCount ballCount;
    // final GameSpeed gameSpeed;
    final BallShape ballShape;
    final GameMode gameMode;
    final double ballSize;

    GameSettings({
        // this.ballCount=BallCount.three,
        // this.gameSpeed=GameSpeed.normal,
        this.ballShape=BallShape.circle,this.ballSize=50.0,this.gameMode=GameMode.normal});
 }