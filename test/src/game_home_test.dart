import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/game_home.dart';
import 'package:gameplugin/src/extensions/ball_count_extention.dart';
import 'package:gameplugin/src/repository/repository.dart';

void main(){

  group("Game Home Test",(){

    Repository.startUp();
    testWidgets("Test if balls are created", (tester) async{

      BallCount ballCount = BallCount.four;
      GameSettings gameSettings = GameSettings(ballCount: ballCount);
      await tester.pumpWidget(MaterialApp(home: GameHome(gameSettings)));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      for(int i=0;i<ballCount.getValue;i++){
        expect(find.byKey(ValueKey(i)), findsOneWidget);
      }
    });
  });

}