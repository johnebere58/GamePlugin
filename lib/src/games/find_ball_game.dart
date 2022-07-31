
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/ball_assets.dart';
import 'package:gameplugin/src/blocs/ball_controller.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/pop_single_text_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/models/ball_info.dart';
import 'package:gameplugin/src/models/game_mode.dart';
import 'package:gameplugin/src/utils/screen_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

import '../blocs/ball_event_controller.dart';
import '../models/ball_count.dart';
import '../models/game_settings.dart';
import '../extensions/ball_count_extention.dart';
import '../widgets/ball_widget.dart';
import 'package:gameplugin/src/extensions/game_mode_extention.dart';
import 'package:gameplugin/src/extensions/ball_count_extention.dart';

class FindBallGame extends StatefulWidget {

  final GameSettings gameSettings;
  const FindBallGame(this.gameSettings,{Key? key}) : super(key: key);

  @override
  _FindBallGameState createState() => _FindBallGameState();
}

class _FindBallGameState extends State<FindBallGame> {

  final List<StreamSubscription> _streamSubscriptions = [];
  final BallEventController _ballEventController = BallEventController.instance;
  final List<Widget> _balls = [];
  late List _ballIds;
  late GameSettings gameSettings;
  int _ballIndexToFind = -1;
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
      if(afresh){
        EndGameController.instance.resetScore();
      }
    }));
    _streamSubscriptions.add(BallController.instance.stream.listen((BallInfo? ballInfo) {
      if(ballInfo==null)return;
      if(_ballIndexToFind==-1)return;

      if(ballInfo.ballId == _ballIndexToFind){
         PopSingleTextController.instance.popCorrect();
         EndGameController.instance.increasePassed();
       }else{
         PopSingleTextController.instance.popWrong();
         EndGameController.instance.increaseFailed();
       }
      _ballIndexToFind=-1;
      if(mounted)setState(() {});
       Future.delayed(const Duration(milliseconds: 1000),(){
         RestartController.instance.restartGame(afresh: false);
       });
    }));

    // Future.delayed(const Duration(milliseconds: 500),(){
    //   RestartController.instance.restartGame();
    // });
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
              children: List.generate(_ballIds.length, (index) {
                Widget ball = _balls[index];
                var key = ball.key;
                // Alignment alignment = getAlignment(key);
                return AnimatedPositioned(
                  // alignment: alignment,
                  top: getTop(key),left:getLeft(key),
                  duration: const Duration(milliseconds: /*ballCount == BallCount.eight?1000:*/500),
                  child: ball, );
              }),
            ),
          ),

          ballToFindTextWidget()
        ],
      ),
    );
  }

  double getTop(var key){
    int itemId =( key as ValueKey).value;
    int position = _ballIds.indexOf(itemId);

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

  double getLeft(var key){
    int itemId =( key as ValueKey).value;
    int position = _ballIds.indexOf(itemId);

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

/*  Alignment getAlignment(var key){
    int itemId =( key as ValueKey).value;
    int position = _ballIds.indexOf(itemId);
    if(ballCount == BallCount.two){
      if(position==0)return Alignment.centerRight;
      if(position==1)return Alignment.centerLeft;
    }
    if(ballCount == BallCount.three){
      if(position==0)return Alignment.topCenter;
      if(position==1)return Alignment.bottomRight;
      if(position==2)return Alignment.bottomLeft;
    }
    if(ballCount == BallCount.four){
      if(position==0)return Alignment.topCenter;
      if(position==1)return Alignment.centerLeft;
      if(position==2)return Alignment.centerRight;
      if(position==3)return Alignment.bottomCenter;
    }

    if(position==0)return Alignment.topCenter;
    if(position==1)return Alignment.centerLeft;
    if(position==2)return Alignment.centerRight;
    if(position==3)return Alignment.bottomCenter;
    if(position==4)return Alignment.topLeft;
    if(position==5)return Alignment.topRight;
    if(position==6)return Alignment.bottomLeft;
    if(position==7)return Alignment.bottomRight;
    return Alignment.bottomLeft;
  }

  double getOffset(var key){
    int itemId =( key as ValueKey).value;
    int position = _ballIds.indexOf(itemId);

    if(position<4)return 0;

    double offset = _screenSize/5;

    return offset;
  }*/


  startShuffle({bool afresh=false})async{
    _showNameOfBallToFind = false;
    setState((){});
    _ballIndexToFind=-1;

    _ballEventController.showBall();

    await Future.delayed( Duration(milliseconds: 2000+(afresh?2000:0)));

    _ballEventController.hideBall();

    int shakeCount = _shuffleCount%5==0?5:_shuffleCount.isEven?2:1;
    shuffleBall(shakeCount,(){
      Future.delayed(const Duration(milliseconds: /*ballCount == BallCount.eight?1000:*/600),(){
        _showNameOfBallToFind = true;
        setState((){});
      });
    });

    _shuffleCount ++;

    _ballIndexToFind = Random().nextInt(_ballIds.length);
  }

  shuffleBall(int counter,onComplete)async{
    if(!mounted)return;
    int newCount = counter-1;
    await Future.delayed(const Duration(milliseconds: 500));
    _ballIds.shuffle();
    if(mounted)setState((){});
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
      child: Text(_ballIndexToFind==-1?"":_allBalls[_ballIndexToFind].ballName,
        style: textStyle(true, 20,
          _ballIndexToFind==-1?Colors.transparent:
          _allBalls[_ballIndexToFind].ballColor,
          ),),
    );
  }
}
