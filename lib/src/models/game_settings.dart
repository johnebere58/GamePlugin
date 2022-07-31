import 'package:gameplugin/src/models/game_mode.dart';

import 'ball_shape.dart';

class GameSettings{

    final BallShape ballShape;
    final GameMode gameMode;
    final double ballSize;
    final int secondsPerRound;
    final int totalRound;

    GameSettings({
        this.ballShape=BallShape.circle,this.ballSize=50.0,
        this.gameMode=GameMode.normal, this.secondsPerRound=6,this.totalRound=10});

    int get gateTime => totalRound * secondsPerRound;
 }