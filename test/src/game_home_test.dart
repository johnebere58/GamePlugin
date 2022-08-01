import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/game_home.dart';
import 'package:gameplugin/src/extensions/ball_count_extention.dart';
import 'package:gameplugin/src/models/game_ids.dart';
import 'package:gameplugin/src/models/game_instruction.dart';
import 'package:gameplugin/src/repository/repository.dart';

void main(){



  group("Game Home Test",(){

    BallCount ballCount = BallCount.four;
    GameSettings gameSettings = GameSettings(gameId: GameIds.find_ball_game);
    Repository.startUp();
    testWidgets("Test if balls are created", (tester) async{

      await tester.pumpWidget(MaterialApp(home: GameHome(gameSettings:gameSettings)));
      await tester.pumpAndSettle(const Duration(seconds: 4));
      for(int i=0;i<ballCount.getValue;i++){
        expect(find.descendant(of: find.byType(SizedBox),
            matching: find.byKey(ValueKey(i))), findsOneWidget);
      }

    });


    testWidgets("test if balls are shuffling", (tester)async {

      await tester.pumpWidget(MaterialApp(home: GameHome(gameSettings: gameSettings)));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      double ballPosition1 = tester.getCenter(find.byKey(const ValueKey(0)),).dx;
      double ballPosition2 = tester.getCenter(find.byKey(const ValueKey(1)),).dx;

      await tester.pumpAndSettle(const Duration(seconds: 4));

      double ballPosition1b = tester.getCenter(find.byKey(const ValueKey(0)),).dx;
      double ballPosition2b = tester.getCenter(find.byKey(const ValueKey(1)),).dx;

      tester.printToConsole("bx1: $ballPosition1, bx1b: $ballPosition1b, bx2: $ballPosition2, bx2b: $ballPosition2b");
      expect(ballPosition1 != ballPosition1b || ballPosition2 != ballPosition2b, true);

      await tester.tap(find.byIcon(Icons.refresh).first);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      ballPosition1 = tester.getCenter(find.byKey(const ValueKey(0)),).dx;
      ballPosition2 = tester.getCenter(find.byKey(const ValueKey(1)),).dx;

      tester.printToConsole("bx1: $ballPosition1, bx1b: $ballPosition1b, bx2: $ballPosition2, bx2b: $ballPosition2b");
      expect(ballPosition1 != ballPosition1b || ballPosition2 != ballPosition2b, true);

    });

    testWidgets("test if you can quit game", (tester)async{
      await tester.pumpWidget(MaterialApp(home: GameHome(
          gameSettings:gameSettings)));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      expect(find.text("Quit Game"), findsOneWidget);

      await tester.tap(find.text("Yes"));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      expect(find.byKey(const ValueKey(0)), findsNothing);

    });

    testWidgets("test if you can switch mode", (tester) async{
      await tester.pumpWidget(MaterialApp(
          home: GameHome(gameSettings:gameSettings)));
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      await tester.tap(find.byIcon(Icons.unfold_more));
      await tester.pumpAndSettle(const Duration(milliseconds: 1000));

      //tests if you can switch the game to 8 modes
      await tester.tap(find.text("8 Ball Game"));
      await tester.pumpAndSettle(const Duration(milliseconds: 4000));

      expect(find.byKey(const ValueKey(7)), findsOneWidget);
    });
  });

}