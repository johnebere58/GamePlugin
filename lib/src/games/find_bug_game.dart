
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/ball_assets.dart';
import 'package:gameplugin/src/assets/string_assets.dart';
import 'package:gameplugin/src/blocs/ball_controller.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/pop_single_text_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/models/ball_info.dart';
import 'package:gameplugin/src/models/game_mode.dart';
import 'package:gameplugin/src/utils/screen_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';
import 'package:gameplugin/src/widgets/bud_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/ball_event_controller.dart';
import '../models/ball_count.dart';
import '../models/game_settings.dart';
import '../extensions/ball_count_extention.dart';
import '../widgets/ball_widget.dart';
import 'package:gameplugin/src/extensions/game_mode_extention.dart';
import 'package:gameplugin/src/extensions/ball_count_extention.dart';
import 'package:animated_rotation/animated_rotation.dart' as anim;

class FindBugGame extends StatefulWidget {

  final GameSettings gameSettings;
  const FindBugGame(this.gameSettings,{Key? key}) : super(key: key);

  @override
  _FindBugGameState createState() => _FindBugGameState();
}

class _FindBugGameState extends State<FindBugGame> {

  final List<StreamSubscription> _streamSubscriptions = [];
  final BallEventController _ballEventController = BallEventController.instance;
  final List<Widget> _balls = [];
  late List _ballIds;
  late GameSettings gameSettings;
  int _bugIndexToFind = -1;
  bool hideBug = false;
  bool _showNameOfBallToFind = false;
  int _shuffleCount = 0;
  late List _allBalls;
  late BallCount ballCount;
  late GameMode gameMode;

  @override
  void initState() {
    gameSettings = widget.gameSettings;
    gameMode = gameSettings.gameMode;
    ballCount = gameMode.getBallCount;
    _allBalls = BallAssets(gameSettings).getAllBalls();
    createBalls();
    _streamSubscriptions.add(RestartController.instance.stream.listen((bool afresh) {
      startShuffle(afresh: afresh);
    }));
    _streamSubscriptions.add(BallController.instance.stream.listen((BallInfo? ballInfo) {
      if(ballInfo==null)return;
      if(_bugIndexToFind==-1)return;

      if(ballInfo.ballId == _bugIndexToFind){
         PopSingleTextController.instance.popCorrect();
         EndGameController.instance.increasePassed();
       }else{
         PopSingleTextController.instance.popWrong();
         EndGameController.instance.increaseFailed();
       }
      _bugIndexToFind=-1;
      if(mounted)setState(() {});

      if(EndGameController.instance.rounds>=gameSettings.totalRound){
        EndGameController.instance.endGame();
        return;
      }

       Future.delayed(const Duration(milliseconds: 1000),(){
         RestartController.instance.restartGame(afresh: false);
       });
    }));

    super.initState();
  }

  @override
  void dispose() {
    for(StreamSubscription stream in _streamSubscriptions) {
      stream.cancel();
    }
    super.dispose();
  }

  void createBalls(){
    _ballIds = List.generate(ballCount.getValue,
            (index) => index);

    for(int i in _ballIds){
      var key = ValueKey(i);
      _balls.add(
          BallWidget(
            _allBalls[i],
            key: key,
          )
      );
    }
    // Future.delayed(Duration(milliseconds: 1000),(){
    //   // startShuffle();
    // });
  }

  double get _screenSize => getScreenHeight(context)/
      (ballCount==BallCount.eight?(2.5):3.5);

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [




          SizedBox(
            width: _screenSize,
            height: _screenSize,
            child: Stack(
              children: [
                bugWidget(),
                Stack(
                  children: List.generate(_ballIds.length, (index) {
                    Widget ball = _balls[index];
                    var key = ball.key;
                    // Alignment alignment = getAlignment(key);
                    return AnimatedPositioned(
                      // alignment: alignment,
                      top: getTop(key),left:getLeft(key),
                      duration: const Duration(milliseconds:500),
                      child: ball, );
                  }),
                ),
              ],
            ),
          ),

          Align(
              alignment: Alignment.topCenter,
              child: SafeArea(child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: ballToFindTextWidget()))),


        ],
      ),
    );
  }

  double getTop(var key,{int? index}){
    int position;
    if(index!=null){
      position = index;
    }else {
      int itemId = (key as ValueKey).value;
      position = index ?? _ballIds.indexOf(itemId);
    }

    int balls = ballCount.getValue;
    double ballSize = gameSettings.ballSize;
    double halfBall = gameSettings.ballSize/2;
    if(balls==2){
      if(position == 0) return _screenSize/2 - (halfBall);
      if(position == 1) return _screenSize/2 - (halfBall);
    }

    if(balls==3){
      if(position == 0) return 0;
      if(position == 1) return _screenSize - (ballSize);
      if(position == 2) return _screenSize - (ballSize);
    }

    double offset = _screenSize/5;
    if(position == 0) return 0;
    if(position == 1) return _screenSize/2 - (halfBall);
    if(position == 2) return _screenSize/2 - (halfBall);
    if(position == 3) return _screenSize - (ballSize);
    if(position == 4) return 0 + (offset);
    if(position == 5) return 0 + (offset);
    if(position == 6) return _screenSize - (offset) - ballSize;
    if(position == 7) return _screenSize - (offset) - ballSize;
    return 0;
  }

  double getLeft(var key,{int? index}){
    int position;
    if(index!=null){
      position = index;
    }else {
      int itemId = (key as ValueKey).value;
      position = index ?? _ballIds.indexOf(itemId);
    }

    int balls = ballCount.getValue;
    double ballSize = gameSettings.ballSize;
    double halfBall = gameSettings.ballSize/2;
    if(balls==2){
      if(position == 0) return 0;
      if(position == 1) return _screenSize - (ballSize);
    }

    if(balls==3){
      if(position == 0) return _screenSize/2 - (halfBall);
      if(position == 1) return 0;
      if(position == 2) return _screenSize - (ballSize);
    }

    double offset = _screenSize/5;
    if(position == 0) return _screenSize/2 - halfBall;
    if(position == 1) return 0;
    if(position == 2) return _screenSize - ballSize;
    if(position == 3) return _screenSize/2 - halfBall;
    if(position == 4) return 0 + offset;
    if(position == 5) return _screenSize - offset - ballSize;
    if(position == 6) return 0 + offset;
    if(position == 7) return _screenSize - offset -ballSize;
    return 0;
  }

  double getAngle(int position){

    double top = getTop(null,index: position);
    double left = getLeft(null,index: position);

    double halfBall = gameSettings.ballSize/2;
    double halfScreen = _screenSize/2 - halfBall;

    if(top==0)return 0;
    double angle = 0;
    if(top>halfScreen) {
      //facing bottom
      angle += 180;
      if (left > halfScreen) {
        angle -= 45;
      } else {
        angle += 45;
      }
    }else{
      //facing top
      if (left > halfScreen) {
        angle += 45;
      } else {
        angle -= 45;
      }
    }
    return angle;
  }



  startShuffle({bool afresh=false})async{
    BallController.instance.canTap=false;
    _ballEventController.hideBall();

    _showNameOfBallToFind = false;
    _bugIndexToFind=-1;
    setState((){});
    await Future.delayed( Duration(milliseconds: 2000));
    _bugIndexToFind = Random().nextInt(_ballIds.length);
    setState((){});
    await Future.delayed( Duration(milliseconds: 1000));
    hideBug = true;
    setState((){});
    // _ballEventController.showBall();

    // await Future.delayed( Duration(milliseconds: 2000+(afresh?2000:0)));

    // _ballEventController.hideBall();

    int shakeCount = _shuffleCount%5==0?5:_shuffleCount.isEven?3:2;
    shuffleBall(shakeCount,(){
      Future.delayed(const Duration(milliseconds: 600),(){
        // _ballEventController.hideBall();
        _showNameOfBallToFind = true;
        setState((){});
        BallController.instance.canTap=true;
      });
    });

    _shuffleCount ++;

    // _bugIndexToFind = Random().nextInt(_ballIds.length);
  }

  shuffleBall(int counter,onComplete)async{
    if(!mounted)return;
    int newCount = counter-1;
    // if(counter==0)_bugIndexToFind = Random().nextInt(_ballIds.length);
    await Future.delayed(const Duration(milliseconds: 500));
    _ballIds.shuffle();
    if(mounted)setState((){});
    // if(counter.isEven)_ballEventController.showBall();
    // if(counter.isOdd)_ballEventController.hideBall();
    if(counter>0){
      shuffleBall(newCount,onComplete);
    }else{
      onComplete();
    }
  }

  Widget ballToFindTextWidget(){

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: !_showNameOfBallToFind? 0:1,
      child: Text(_bugIndexToFind==-1?"":"Find the bug",
        style: textStyle(true, 25, Colors.blue,
          ),),
    );
  }

  Widget bugWidget(){

    int? bugPosition;
    if(_bugIndexToFind!=-1) {
      bugPosition = _ballIds.indexOf(_bugIndexToFind);
    }
    double halfBall = gameSettings.ballSize/2;
    return AnimatedPositioned(
      // alignment: alignment,
      top: bugPosition==null?(
          (_screenSize/2)-(halfBall)
      ): getTop(null,index: bugPosition),
      left: bugPosition==null?(
          (_screenSize/2)-(halfBall)
      ):
      getLeft(null, index: bugPosition),

      duration: const Duration(milliseconds:500),
      child:  anim.AnimatedRotation(
        duration: const Duration(milliseconds: 200), angle: bugPosition==null?0:getAngle(bugPosition!),
        child: Container(
            alignment: Alignment.center,
            width: gameSettings.ballSize,
            height: gameSettings.ballSize,
            child: const BugWidget(key: ValueKey("bug"))),
      ), );
  }
}
