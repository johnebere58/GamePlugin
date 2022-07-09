import 'package:flutter/material.dart';
import 'package:gameplugin/src/settings/ball_shape.dart';

class BallInfo{

    /// This is to set the size, color and  shape of the ball

    final double ballSize;
    final Color ballColor;
    final BallShape ballShape;
    final String ballName;
    final int ballId;

    BallInfo({required this.ballSize, required this.ballColor,
    required this.ballShape, required this.ballName, required this.ballId});
 }