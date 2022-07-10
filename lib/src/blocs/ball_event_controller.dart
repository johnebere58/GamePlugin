
import 'dart:async';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_events.dart';

class BallEventController {

  static BallEventController get instance => getIt<BallEventController>();

  // BallEventController._();
  //
  // factory BallEventController()=>BallEventController._();

  final StreamController<BallEvents> _streamController = StreamController.broadcast();

  Stream<BallEvents> get stream => _streamController.stream;

  void hideBall()=> _streamController.add(BallEvents(hideBall: true));
  void showBall()=> _streamController.add(BallEvents(hideBall: false));

 }