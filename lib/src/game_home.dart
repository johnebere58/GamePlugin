
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/assets/string_assets.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/game_settings_controller.dart';
import 'package:gameplugin/src/blocs/pop_single_text_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/blocs/timer_controller.dart';
import 'package:gameplugin/src/games/find_bug_game.dart';
import 'package:gameplugin/src/models/game_instruction.dart';
import 'package:gameplugin/src/models/game_settings.dart';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/pages/game_settings_page.dart';
import 'package:gameplugin/src/utils/dailog_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';
import 'package:gameplugin/src/widgets/countdown_timer_widget.dart';
import 'package:gameplugin/src/widgets/game_end_widget.dart';
import 'package:gameplugin/src/widgets/pop_text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'games/find_ball_game.dart';
import 'extensions/ball_count_extention.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gameplugin/src/extensions/game_id_extention.dart';


class GameHome extends StatefulWidget {
  final GameSettings gameSettings;
  const GameHome({required this.gameSettings,
    Key? key}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> with TickerProviderStateMixin, WidgetsBindingObserver {


  late GameSettings _gameSettings;
  final List<StreamSubscription> _streamSubscriptions = [];
  late AnimationController _animationController;
  bool enableSound = false;
  bool enableVibrate = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool gamePaused = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSound();
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
    _streamSubscriptions.add(
        PopSingleTextController.
        instance.stream.listen((event) {
          playSound(correct: event.isCorrect);
        }));

    _streamSubscriptions.add(
        GameSettingsController.
        instance.stream.listen((event) {
          _gameSettings=event;
          if(mounted)setState((){});
          // if(!TimerController.instance.timeUp) {
          //   RestartController.instance.restartGame(afresh: true);
          // }
        }));



    WidgetsBinding.instance.addObserver(this);

    checkSettings();
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
    WidgetsBinding.instance.removeObserver(this);
    audioPlayer.dispose();
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

              if(_gameSettings.gameId==GameIds.find_ball_game)
                FindBallGame(_gameSettings,key: ValueKey(_gameSettings.gameMode.index),),

              if(_gameSettings.gameId==GameIds.find_bug_game)
                FindBugGame(_gameSettings,key: ValueKey(_gameSettings.gameMode.index),),

              restartButton(),



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

              pauseButton(),

              const PopTextWidget(),

              // pauseWidget(),

              introScreen(),

              quitButton(),

              GameEndWidget(gameSettings: _gameSettings,onQuit: (){
                clickQuit();
              },),

              settingsButton(),
            ]
        ),
      ),
    );
  }

 Widget pauseButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 140,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{
              pauseGame();
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
            child: const Icon(Icons.pause_circle_filled,
              color: black,),
          ),
        ),
      ),);
}

Widget restartButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 80,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{
              yesNoDialog(context, "Restart Game", "are you sure?", (){
                restartGame();
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
          margin: const EdgeInsets.only(top: 20,right: 20,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{
              pauseGame();
              launchNewScreen(context, GameSettingsPage(_gameSettings),
              result: (_){

                if(TimerController.instance.timeUp)return;

                if(_==true){
                  restartGame();
                }else{
                  resumeGame();
                }

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
            child: const Icon(Icons.settings_outlined,
              color: black,),
          ),
        ),
      ),);
  }


  clickQuit(){
    yesNoDialog(context, "Quit Game", "Are you sure?", (){
      Navigator.pop(context,false);
    });
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
                clickQuit();
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
              addSpace(80),
              Text(_gameSettings.gameId.title,style: textStyle(true, 35, black),),
              addSpace(10),
              Text(_gameSettings.gameId.description,style: textStyle(false, 16, black),),
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
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0)
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Start",style: textStyle(true, 24, black),),
                      addSpaceWidth(5),
                      const Icon(Icons.arrow_right,size: 40,color: black,)
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


 void pauseGame(){
  gamePaused=true;
  TimerController.instance.pause();
  audioPlayer.stop();
  checkSettings();
  if(mounted)setState(() {});
 }

 void resumeGame(){
  gamePaused=false;
  TimerController.instance.resume();
  checkSettings();
  if(mounted)setState(() {});
 }

 void restartGame(){
   gamePaused=false;
  TimerController.instance.resetTimer();
  EndGameController.instance.resetScore();
  RestartController.instance.restartGame(afresh: true);
  checkSettings();
   if(mounted)setState(() {});
 }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    if (state == AppLifecycleState.paused) {
      pauseGame();
    }
    if (state == AppLifecycleState.resumed) {
      resumeGame();
    }

    super.didChangeAppLifecycleState(state);
  }


  checkSettings()async{
    SharedPreferences shed = await SharedPreferences.getInstance();
    enableSound = shed.getBool(soundKey)??false;
    enableVibrate = shed.getBool(vibrateKey)??false;
    if(mounted)setState((){});
  }

  late Uint8List correctSoundData;
  late Uint8List wrongSoundData;
  loadSound()async{
    final cdata = await rootBundle.load('packages/gameplugin/assets/sounds/slow.mp3');
    final wdata = await rootBundle.load('packages/gameplugin/assets/sounds/error.mp3');

    correctSoundData = cdata.buffer.asUint8List(cdata.offsetInBytes, cdata.lengthInBytes);
    wrongSoundData = wdata.buffer.asUint8List(wdata.offsetInBytes, wdata.lengthInBytes);
  }

  playSound({required bool correct}){
   if(!enableSound)return;
   if(correct)audioPlayer.play(BytesSource(correctSoundData));
   if(!correct)audioPlayer.play(BytesSource(wrongSoundData));
   vibrate();
}

  vibrate(){
  if(!enableVibrate)return;
  Vibration.vibrate(
    duration:100
  );
  }

  Widget pauseWidget(){


    return IgnorePointer(
      ignoring: !gamePaused,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: !gamePaused?0:1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              opacity: 1,duration: const Duration(milliseconds: 300),
              child: ClipRect(
                  child:BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        color: Colors.white.withOpacity(.5),
                      ))
              ),
            ),
            Container(
              margin: const EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pause_circle_outline,size: 100,),
                  addSpace(20),
                  Text(
                      "Game Paused",
                      style: textStyle(true, 23, black),textAlign: TextAlign.center),


                  addSpace(20),

                  Row(
                    children: [

                      Flexible(fit: FlexFit.tight,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            onPressed: (){
                              resumeGame();
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: black,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Resume",style: textStyle(true, 20, white),),
                                // addSpaceWidth(5),
                                // const Icon(Icons.refresh,size: 25,color: white,)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
