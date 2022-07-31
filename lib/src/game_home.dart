
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/models/game_instruction.dart';
import 'package:gameplugin/src/models/game_settings.dart';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/utils/dailog_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';
import 'package:gameplugin/src/widgets/countdown_timer_widget.dart';
import 'package:gameplugin/src/widgets/game_end_widget.dart';
import 'package:gameplugin/src/widgets/pop_text_widget.dart';

import 'games/find_ball_game.dart';
import 'extensions/ball_count_extention.dart';


class GameHome extends StatefulWidget {
  final GameSettings gameSettings;
  final GameInstruction gameInstruction;
  const GameHome({required this.gameSettings,required this.gameInstruction,
    Key? key}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> with TickerProviderStateMixin {


  late GameSettings _gameSettings;
  late GameInstruction _gameInstruction;
  final List<StreamSubscription> _streamSubscriptions = [];
  late AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gameSettings = widget.gameSettings;
    _gameInstruction = widget.gameInstruction;

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

              FindBallGame(_gameSettings,key: ValueKey(_gameSettings.gameMode.index),),

              restartButton(),

              settingsButton(),

              if(!showIntro)SafeArea(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(75, 28, 0, 0),
                  child: CountDownTimerWidget(
                    time: _gameSettings.gateTime,onComplete: (){
                      EndGameController.instance.endGame();
                  },
                  ),
                ),
              ),

              const PopTextWidget(),

              introScreen(),

              quitButton(),

              GameEndWidget(gameSettings: _gameSettings)
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
              RestartController.instance.restartGame(afresh: true);
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

Widget settingsButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 80,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{

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
            child: const Icon(Icons.settings_outlined,
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
               _gameSettings = GameSettings(
                   // gameSpeed: _gameSettings.gameSpeed,
                   ballShape: _gameSettings.ballShape,
                 // ballCount: ballCount,
                   ballSize: _gameSettings.ballSize);
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

bool showIntro = true;

Widget introScreen(){

    return SafeArea(
      child: IgnorePointer(ignoring: !showIntro,
        child: AnimatedOpacity(opacity: showIntro?1:0,
            duration: const Duration(milliseconds: 500),
        child: Container(
          padding: const EdgeInsets.all(20),
          color: white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addSpace(60),
              Text(_gameInstruction.title,style: textStyle(true, 30, black),),
              addSpace(10),
              Text(_gameInstruction.description,style: textStyle(false, 16, black),),
              Expanded(child: Container()),
              Align(alignment: Alignment.topRight,
              child:  SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: (){
                    setState((){
                      showIntro=false;
                    });
                    RestartController.instance.restartGame(afresh: true);

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Start",style: textStyle(true, 24, black),),
                      addSpaceWidth(5),
                      const Icon(Icons.arrow_right_alt,size: 30,color: black,)
                    ],
                  ),
                ),
              ),)
            ],
          ),
        ),),
      ),
    );
}

}
