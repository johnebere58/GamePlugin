
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/settings/game_settings.dart';
import 'package:gameplugin/src/utils/dailog_utils.dart';
import 'package:gameplugin/src/utils/pop_text_widget.dart';

import 'blocs/ball_controller.dart';
import 'games/find_ball_game.dart';


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
    return Container(
      color: white,
      child: Stack(fit: StackFit.expand,
          children:
          [
            // LiquidLinearProgressIndicator(direction: Axis.vertical,
            //   backgroundColor: transparent,
            //   value: _animationController.value,valueColor
            //       : AlwaysStoppedAnimation<Color>(
            //       default_white
            //   ),
            // ),

            FindBallGame(_gameSettings),

            restartButton(),

            quitButton(),

            const PopTextWidget(),


          ]

      ),
    );
  }

 Widget restartButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 20),
          child: ElevatedButton(
            onPressed: ()async{
              RestartController.instance.restartGame();
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: CircleBorder(
                    side: BorderSide(
                        color: black.withOpacity(.1)
                    )
                ),
                primary: default_white
            ),
            child: const Icon(Icons.refresh,
              color: black,),
          ),
        ),
      ),);
}

 Widget quitButton(){

    return Align(alignment: Alignment.topLeft,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,left: 20),
          child: ElevatedButton(
            onPressed: ()async{
              yesNoDialog(context, "Quit Game", "Are you sure?", (){
                Navigator.pop(context,false);
              });
            },
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                shape: CircleBorder(
                    side: BorderSide(
                        color: black.withOpacity(.1)
                    )
                ),
                primary: default_white
            ),
            child: const Icon(Icons.close,
              color: black,),
          ),
        ),
      ),);
}
}
