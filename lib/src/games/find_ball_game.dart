
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/ball_assets.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/utils/screen_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

import '../blocs/ball_event_controller.dart';
import '../settings/ball_count.dart';
import '../settings/game_settings.dart';
import '../extensions/ball_count_extention.dart';
import '../widgets/ball_widget.dart';

class FindBallGame extends StatefulWidget {

  final GameSettings gameSettings;
  const FindBallGame(this.gameSettings,{Key? key}) : super(key: key);

  @override
  _FindBallGameState createState() => _FindBallGameState();
}

class _FindBallGameState extends State<FindBallGame> {

  final List<StreamSubscription> _streamSubscriptions = [];
  final BallEventController _ballEventController = BallEventController.instance;
  late List<Widget> _balls;
  late List _ballIds;
  late GameSettings _gameSettings;
  late double _screenSize;
  int _ballIndexToFind = -1;
  bool _showNameOfBallToFind = false;
  int _shuffleCount = 0;
  late List _allBalls;

  @override
  void initState() {
    _allBalls = BallAssets(_gameSettings).getAllBalls();
    _screenSize = getScreenHeight(context)/3.5;
    _gameSettings = widget.gameSettings;
    createBalls();
    _streamSubscriptions.add(RestartController.instance.stream.listen((bool afresh) {
         Future.delayed(const Duration(seconds: 1),(){
           startShuffle();
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
    _ballIds = List.generate(_gameSettings.ballCount.getValue, (index) => index);

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


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: _screenSize,
          height: _screenSize,
          child: Stack(
            children: List.generate(_ballIds.length, (index) {
              Widget ball = _balls[index];
              var key = ball.key;
              Alignment alignment = getAlignment(key);
              return AnimatedAlign(
                alignment: alignment,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  margin: EdgeInsets.all(getOffset(key)),
                  child: ball,
                ), );
            }),
          ),
        ),

        ballToFindTextWidget()
      ],
    );
  }

  Alignment getAlignment(var key){
    int itemId =( key as ValueKey).value;
    int position = _ballIds.indexOf(itemId);
    if(_gameSettings.ballCount == BallCount.two){
      if(position==0)return Alignment.centerRight;
      if(position==1)return Alignment.centerLeft;
    }
    if(_gameSettings.ballCount == BallCount.three){
      if(position==0)return Alignment.topCenter;
      if(position==1)return Alignment.bottomRight;
      if(position==2)return Alignment.bottomLeft;
    }
    if(_gameSettings.ballCount == BallCount.four){
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

    if(position<5)return 0;

    double offset = _screenSize/5;

    return offset;
  }


  startShuffle()async{
    _showNameOfBallToFind = false;
    setState((){});
    _ballIndexToFind=-1;

    _ballEventController.showBall();

    await Future.delayed(const Duration(milliseconds: 2000));

    _ballEventController.hideBall();

    int shakeCount = _shuffleCount%5==0?5:_shuffleCount.isEven?2:1;
    shuffleBall(shakeCount,(){
      Future.delayed(const Duration(milliseconds: 600),(){
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

    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: !_showNameOfBallToFind? 0:1,
          child: Text(_ballIndexToFind==-1?"":_allBalls[_ballIndexToFind].ballName,
            style: textStyle(true, 30,
              _ballIndexToFind==-1?Colors.transparent:
              _allBalls[_ballIndexToFind].ballColor,
              shadowOffset: .1,withShadow: true,),),
        ));
  }
}
