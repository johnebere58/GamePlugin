import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/blocs/ball_controller.dart';
import 'package:gameplugin/src/blocs/ball_event_controller.dart';
import 'package:gameplugin/src/models/ball_events.dart';
import 'package:gameplugin/src/models/ball_info.dart';


/// Ball Widget used to create square or circle balls
///
/// [BallInfo] is used to set the design of the ball
///
/// Each ball is attached with a stream controller to listen to changes on the ball

class BallWidget extends StatefulWidget {
  final BallInfo ballInfo;
  const BallWidget(this.ballInfo,{Key? key}) : super(key: key);

  @override
  State<BallWidget> createState() => _BallWidgetState();
}

class _BallWidgetState extends State<BallWidget> {

  final BallEventController _ballEventController = BallEventController.instance;
  final BallController _ballController = BallController.instance;
  late BallEvents _ballEvents;
  late StreamSubscription _ballSub;
  BallInfo? _ballInfo;
  bool _hideBall = false;

  @override
  void initState() {
    _ballInfo = widget.ballInfo;
    _ballSub = _ballEventController.stream.listen((BallEvents event) {
      setState(() {
        _ballEvents = event;
        _hideBall = _ballEvents.hideBall;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ballSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Color color = _ballInfo!.ballColor;
    BallShape ballShape = _ballInfo!.ballShape;
    return GestureDetector(
      onTap: (){
        _ballController.ballTapped(_ballInfo);
      },
      child: SizedBox(
          width: _ballInfo!.ballSize,
          height: _ballInfo!.ballSize,
          child: Card(
            margin: EdgeInsets.zero,
            shape:

                ballShape == BallShape.square?
               RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(5),
                   side: BorderSide(
                       color: !_hideBall ? Colors.transparent : Colors.black
                           .withOpacity(.4),
                       width: 2
                   )
               )
              :
            CircleBorder(
                side: BorderSide(
                    color: !_hideBall ? Colors.transparent : Colors.black
                        .withOpacity(.4),
                    width: 2
                )
            ),
            color: _hideBall ? Colors.white : color,
            elevation: 10,
            shadowColor: Colors.black.withOpacity(.3),
          )),
    );
  }
}