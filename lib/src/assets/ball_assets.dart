
 import 'package:flutter/material.dart';

import '../models/ball_info.dart';
import '../models/ball_shape.dart';
import '../models/game_settings.dart';

class BallAssets{

  final GameSettings _gameSettings;
  BallAssets(this._gameSettings);

  List getAllBalls(){
    BallShape ballShape = _gameSettings.ballShape;
    double ballSize = _gameSettings.ballSize;
    return [
      BallInfo(ballColor: Colors.blue,ballId: 0,ballName: "Blue",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.red,ballId: 1,ballName: "Red",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.green,ballId: 2,ballName: "Green",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.grey,ballId: 3,ballName: "Grey",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.orange,ballId: 4,ballName: "Orange",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.yellow,ballId: 5,ballName: "Yellow",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.purple,ballId: 6,ballName: "Purple",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.brown,ballId: 7, ballName: "Brown",ballShape:ballShape,ballSize:ballSize,),
    ];
  }
}