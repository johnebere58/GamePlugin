
import 'package:flutter/material.dart';
import 'package:gameplugin/src/game_home.dart';
import 'package:gameplugin/src/models/game_instruction.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

import '../gameplugin.dart';
import 'repository/repository.dart';
import 'models/game_settings.dart';

class GameManager{

   static bool initialized = false;

   ///very important please call this method first
   static initialize(){
     if(!initialized) {
       Repository.startUp();
       initialized = true;
     }
   }

   void launchGame(BuildContext context,
       {required GameSettings gameSettings,
       required GameInstruction gameInstruction}){
     //uses default game settings if no settings was added
     // gameSettings = gameSettings ?? GameSettings();
     if(!initialized){
       throw Exception("game not initialized, please call [GameManager.initialize] first");
     }
     launchNewScreen(context, GameHome(gameSettings:gameSettings,
         gameInstruction: gameInstruction));
   }

 }