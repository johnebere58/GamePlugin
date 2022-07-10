import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/game_home.dart';
import 'package:gameplugin/src/extensions/ball_count_extention.dart';
import 'package:gameplugin/src/repository/repository.dart';
import 'package:integration_test/integration_test.dart';

void main(){

  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
    as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  });

}