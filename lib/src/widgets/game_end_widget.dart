import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/extensions/game_mode_extention.dart';
import 'package:gameplugin/src/models/game_settings.dart';
import 'package:gameplugin/src/models/score_model.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

class GameEndWidget extends StatefulWidget {
  final GameSettings gameSettings;
  const GameEndWidget({required this.gameSettings,
   Key? key}):super(key:key);
   @override
   _GameEndWidgetState createState() => _GameEndWidgetState();
 }

 class _GameEndWidgetState extends State<GameEndWidget> {


  late GameSettings gameSettings;
  ScoreModel scoreModel = ScoreModel();
  final List<StreamSubscription> _streamSubscriptions = [];
  @override
  void initState() {
    gameSettings = widget.gameSettings;
    super.initState();

    _streamSubscriptions.add(EndGameController.instance.stream.listen((score) {
      scoreModel = score;
      if(mounted)setState((){});
    }));

  }

  int get roundsPlayed => scoreModel.totalFailed + scoreModel.totalPassed;
  double get roundsCompleted => (roundsPlayed / gameSettings.totalRound) * 100;
  double get gameAccuracy => (scoreModel.totalPassed/roundsPlayed) * 100;
  double get score => (gameAccuracy + roundsCompleted)/2;
  double get passPercentage => gameSettings.gameMode.passPercentage;
  bool get passed => score >= passPercentage;

  @override
  void dispose() {
    for(StreamSubscription stream in _streamSubscriptions) {
      stream.cancel();
    }
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {
     return page();
   }

   Widget page(){


     return IgnorePointer(
       ignoring: scoreModel.totalPlayed!=0,
       child: AnimatedOpacity(
         duration: const Duration(milliseconds: 500),
         opacity: scoreModel.totalPlayed==0?0:1,
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
               child: Card(
                 elevation: 0,
                 color: white,
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Image.asset(
                       "assets/images/${passed?"mood2":"mood4"}.png",package: "gameplugin",
                     color: black,
                     height: 100,),
                     // addSpace(10),
                     Text(
                         passed?
                             "Awesome. You did great"
                             :"Oops. You can to try a little more",
                         style: textStyle(true, 23, black),textAlign: TextAlign.center),

                     addSpace(20),
                     Stack(
                       alignment: Alignment.topCenter,
                       children: [
                         Container(
                           margin: EdgeInsets.fromLTRB(0,35,0,0),
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
                                     Text("$roundsPlayed/${gameSettings.totalRound}",style: textStyle(false, 14, black.withOpacity(.5)),),
                                     addSpace(5),
                                     Text("Rounds",style: textStyle(true, 16, black),),

                                     ],
                                 ),
                               ),
                               Container(
                                 color: black.withOpacity(.1),width: .5,
                                 height: 50,
                               ),
                               Flexible(fit: FlexFit.tight,
                                 child: Container()
                               ),

                               Container(
                                 color: black.withOpacity(.1),width: .5,
                                 height: 50,
                               ),
                               Flexible(fit: FlexFit.tight,
                                 child: Column(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Text("$gameAccuracy%",style: textStyle(false, 14, black.withOpacity(.5)),),

                                     addSpace(5),

                                     Text("Accuracy",style: textStyle(true, 16, black),),

                                     ],
                                 ),
                               ),


                             ],
                           ),
                         ),
                         Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Container(
                                 width: 60,height: 60,
                                 decoration: BoxDecoration(
                                   color: passed?blue0:black,shape: BoxShape.circle
                                 ),
                                 alignment: Alignment.center,
                                 child: Text("$score%",style: textStyle(true, 18, white),)),
                             addSpace(5),
                             Text("Score",style: textStyle(true, 16, black),),

                           ],
                         ),
                       ],
                     ),
                     Container(
                       margin: const EdgeInsets.only(top: 20),
                       child: Text("Score up to ${passPercentage}% to pass the game",
                           style: textStyle(false, 14, black),
                           textAlign: TextAlign.center),
                     ),
                     addSpace(20),

                     Row(
                       children: [
                         Flexible(fit: FlexFit.tight,
                           child: Container(
                             height: 50,
                             width: double.infinity,
                             child: TextButton(
                               onPressed: (){

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
                                   Text("Quit",style: textStyle(true, 20, white),),
                                   // addSpaceWidth(5),
                                   // const Icon(Icons.close,size: 25,color: white,)
                                 ],
                               ),
                             ),
                           ),
                         ),
                         addSpaceWidth(20),
                         Flexible(fit: FlexFit.tight,
                           child: Container(
                             width: double.infinity,
                             height: 50,
                             child: TextButton(
                               onPressed: (){
                                 RestartController.instance.restartGame(afresh: true);
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
                                   Text("Restart",style: textStyle(true, 20, white),),
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
               ),
             )
           ],
         ),
       ),
     );
   }
 }
