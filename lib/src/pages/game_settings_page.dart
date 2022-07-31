import 'package:flutter/material.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/assets/color_assets.dart';
import 'package:gameplugin/src/utils/dailog_utils.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';
import 'package:gameplugin/src/extensions/game_mode_extention.dart';

class GameSettingsPage extends StatefulWidget {
  final GameSettings gameSettings;

  const GameSettingsPage(this.gameSettings,{Key? key}) : super(key: key);

   @override
   _GameSettingsPageState createState() => _GameSettingsPageState();
 }

 class _GameSettingsPageState extends State<GameSettingsPage> {

  late GameSettings gameSettings;
  bool reset = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gameSettings = widget.gameSettings;
  }

   @override
   Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: (){
         Navigator.pop(context,reset);
         return Future.value(true);
       },
       child: Scaffold(
         backgroundColor: white,
         body: SafeArea(
           child: Column(
             children: [
               addSpace(20),
               Row(
                 children: [
                   addSpaceWidth(20),
                   SizedBox(
                     width: 40,height: 40,
                     child: ElevatedButton(
                       onPressed: ()async{
                         Navigator.pop(context,reset);
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
                       child: const Icon(Icons.arrow_back,
                         color: black,),
                     ),
                   ),
                   addSpaceWidth(10),
                   Text("Game Settings",style: textStyle(true, 20, black),)
                 ],
               ),
               Expanded(child: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(0,0,0,0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       addSpace(20),
                       Container(
                         color: white,
                         // height: 50,
                         child: TextButton(
                           onPressed: (){

                             List items = List.generate(GameMode.values.length,
                                     (index) => GameMode.values[index].name);
                             showListDialog(context, items, (i){
                               gameSettings.gameMode = GameMode.values[i];
                               reset = true;
                               setState(() {});
                             },returnIndex: true,title: "Game Mode");
                           },
                           style: TextButton.styleFrom(
                             padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(0)
                             )
                           ),
                           child: Row(
                             children: [
                               Flexible(fit: FlexFit.tight,
                                   child: Text("Game Mode",style: textStyle(false, 18, Colors.black),)),
                               Text(gameSettings.gameMode.name,style: textStyle(true, 18, black),),
                               addSpaceWidth(5),
                               const Icon(Icons.arrow_drop_down_circle)
                             ],
                           ),
                         ),
                       ),
                       addLine(.5, black.withOpacity(.1), 0, 0, 0, 0)
                     ],
                   ),
                 ),
               ))
             ],
           ),
         ),
       ),
     );
   }
 }
