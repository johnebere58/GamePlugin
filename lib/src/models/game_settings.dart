import 'package:gameplugin/src/models/game_ids.dart';
import 'package:gameplugin/src/models/game_mode.dart';

import 'ball_shape.dart';

class GameSettings{

    final BallShape ballShape;
    GameMode gameMode;
    final double ballSize;
    final int secondsPerRound;
    final int totalRound;
    final GameIds gameId;

    GameSettings({
        required this.gameId,
        this.ballShape=BallShape.circle,this.ballSize=50.0,
        this.gameMode=GameMode.normal, this.secondsPerRound=7,this.totalRound=10});

    int get gateTime => totalRound * secondsPerRound;
 }