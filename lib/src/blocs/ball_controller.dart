
import 'dart:async';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';

class BallController {

  static BallController get instance => getIt<BallController>();

  final StreamController<BallInfo?> _streamController = StreamController.broadcast();

  Stream<BallInfo?> get stream => _streamController.stream;

  bool canTap = false;

  void ballTapped(BallInfo? ball){
    _streamController.add(ball);
  }

 }