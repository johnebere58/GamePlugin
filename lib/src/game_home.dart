
import 'dart:async';
import 'dart:typed_data';
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


class GameHome extends StatefulWidget {
  final GameSettings gameSettings;
  final GameInstruction gameInstruction;
  const GameHome({required this.gameSettings,required this.gameInstruction,
    Key? key}) : super(key: key);

  @override
  State<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends State<GameHome> with TickerProviderStateMixin, WidgetsBindingObserver {


  late GameSettings _gameSettings;
  late GameInstruction _gameInstruction;
  final List<StreamSubscription> _streamSubscriptions = [];
  late AnimationController _animationController;
  bool enableSound = false;
  bool enableVibrate = false;
  AudioPlayer audioPlayer = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSound();
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

              FindBallGame(_gameSettings,key: ValueKey(_gameSettings.gameMode.index),),

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

              const PopTextWidget(),

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

 Widget restartButton(){
    return Align(alignment: Alignment.topRight,
      child: SafeArea(
        child: Container(
          width: 40,height: 40,
          margin: const EdgeInsets.only(top: 20,right: 80,bottom: 20),
          child: ElevatedButton(
            onPressed: ()async{
              restartGame();
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
              Text(_gameInstruction.title,style: textStyle(true, 35, black),),
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
  TimerController.instance.pause();
  audioPlayer.stop();
  checkSettings();
 }

 void resumeGame(){
  TimerController.instance.resume();
  checkSettings();
 }

 void restartGame(){
  TimerController.instance.resetTimer();
  EndGameController.instance.resetScore();
  RestartController.instance.restartGame(afresh: true);
  checkSettings();
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
}
