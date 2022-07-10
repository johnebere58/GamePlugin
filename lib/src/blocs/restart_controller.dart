
import 'dart:async';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:gameplugin/src/models/ball_info.dart';

class RestartController {

  static RestartController get instance => getIt<RestartController>();

  final StreamController<bool> _streamController = StreamController.broadcast();

  Stream<bool> get stream => _streamController.stream;

  void restartGame({bool afresh=false}) {
    _streamController.add(afresh);
  }

 }