
 import 'package:flutter/material.dart';

import '../settings/ball_info.dart';
import '../settings/ball_info.dart';
import '../settings/ball_shape.dart';
import '../settings/ball_shape.dart';
import '../settings/game_settings.dart';

class BallAssets{

  final GameSettings _gameSettings;
  BallAssets(this._gameSettings);

  List getAllBalls(){
    BallShape ballShape = _gameSettings.ballShape;
    double ballSize = _gameSettings.ballSize;
    return [
      BallInfo(ballColor: Colors.blue,ballId: 0,ballName: "Blue",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.red,ballId: 0,ballName: "Red",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.green,ballId: 0,ballName: "Green",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.grey,ballId: 0,ballName: "Grey",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.orange,ballId: 0,ballName: "Orange",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.yellow,ballId: 0,ballName: "Yellow",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.purple,ballId: 0,ballName: "Purple",ballShape:ballShape,ballSize:ballSize,),
      BallInfo(ballColor: Colors.brown,ballId: 0,ballName: "Brown",ballShape:ballShape,ballSize:ballSize,),
    ];
  }
}