
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/blocs/ball_event_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/models/game_settings.dart';
import 'package:gameplugin/src/utils/dailog_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';
import 'package:gameplugin/src/widgets/pop_text_widget.dart';

import 'games/find_ball_game.dart';
import 'extensions/ball_count_extention.dart';


class GameHome extends StatefulWidget {
  final GameSettings gameSettings;
  const GameHome(this.gameSettings,{Key? key}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> with TickerProviderStateMixin {


  late GameSettings _gameSettings;
  final List<StreamSubscription> _streamSubscriptions = [];
  late AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gameSettings = widget.gameSettings;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20000),
    );
    _animationController.addListener(
            () {
          if(!mounted)return;
          if(_animationController.isCompleted){
            endGame();
          }
          if(mounted)setState(() {});
        }
    );

  }


  void endGame(){
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    for(StreamSubscription stream in _streamSubscriptions) {
      stream.cancel();
    }
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: Stack(//fit: StackFit.expand,
            children:
            [
              // LiquidLinearProgressIndicator(direction: Axis.vertical,
              //   backgroundColor: transparent,
              //   value: _animationController.value,valueColor
              //       : AlwaysStoppedAnimation<Color>(
              //       default_white
              //   ),
              // ),

              FindBallGame(_gameSettings,key: ValueKey(_gameSettings.ballCount.index),),

              restartButton(),

              switchGameButton(),

              quitButton(),

              const PopTextWidget(),

              scoreBoard()
            ]

        ),
      ),
    );
  }

 Widget restartButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 20,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{
              RestartController.instance.restartGame();
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape:  CircleBorder(
                    side: BorderSide(
                        color: black.withOpacity(.1),width: 1
                    )
                ),
                elevation: 5,shadowColor: black.withOpacity(.1),
                primary: white
            ),
            child: const Icon(Icons.refresh,
              color: black,),
          ),
        ),
      ),);
}

  Widget switchGameButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 80,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{
              List<BallCount> balls = BallCount.values.toList();
              List items = List.generate(balls.length, (index) => "${balls[index].getValue} Ball Game");
             showListDialog(context, items, (i){
               BallCount ballCount = balls[i];
               _gameSettings = GameSettings(gameSpeed: _gameSettings.gameSpeed,ballShape: _gameSettings.ballShape,
                 ballCount: ballCount,ballSize: _gameSettings.ballSize);
               setState(() {});
             },returnIndex: true);
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape:  CircleBorder(
                  side: BorderSide(
                    color: black.withOpacity(.1),width: 1
                  )
                ),
                elevation: 5,shadowColor: black.withOpacity(.1),
                primary: white
            ),
            child: const Icon(Icons.unfold_more,
              color: black,),
          ),
        ),
      ),);
  }


 Widget quitButton(){

    return Align(alignment: Alignment.topLeft,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20,left: 20,right: 20),
          child: SizedBox(
            width: 40,height: 40,
            child: ElevatedButton(
              onPressed: ()async{
                yesNoDialog(context, "Quit Game", "Are you sure?", (){
                  Navigator.pop(context,false);
                });
              },
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  shape:  CircleBorder(
                      side: BorderSide(
                          color: black.withOpacity(.1),width: 1
                      )
                  ),
                  elevation: 5,shadowColor: black.withOpacity(.1),
                  primary: white
              ),
              child: const Icon(Icons.close,
                color: black,),
            ),
          ),
        ),
      ),);
}

Widget scoreBoard(){

    return Align(alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.all(20),
        width: double.infinity,
        // height: 100,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: default_white,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Flexible(fit: FlexFit.tight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Score",style: textStyle(true, 14, black),),
                  // addLine(.5, black.withOpacity(.1), 0, 5, 0, 5),
                  addSpace(5),
                  Text("10",style: textStyle(false, 14, black.withOpacity(.5)),),
                ],
              ),
            ),
            Container(
              color: black.withOpacity(.1),width: .5,
              height: 50,
            ),
            Flexible(fit: FlexFit.tight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Round",style: textStyle(true, 14, black),),
                  // addLine(.5, black.withOpacity(.1), 0, 5, 0, 5),
                  addSpace(5),
                  Text("1/10",style: textStyle(false, 14, black.withOpacity(.5)),),
                ],
              ),
            ),
            Container(
              color: black.withOpacity(.1),width: .5,
              height: 50,
            ),
            Flexible(fit: FlexFit.tight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Difficulty",style: textStyle(true, 14, black),),
                  // addLine(.5, black.withOpacity(.1), 0, 5, 0, 5),
                  addSpace(5),
                  Text("Easy",style: textStyle(false, 14, black.withOpacity(.5)),),
                ],
              ),
            ),


          ],
        ),
      ),
    );
}
}
