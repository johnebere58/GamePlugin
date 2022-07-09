
import 'package:flutter/material.dart';
import 'package:gameplugin/src/game_home.dart';
import 'package:gameplugin/src/utils/widget_utils.dart';

import '../gameplugin.dart';
import 'repository/repository.dart';
import 'models/game_settings.dart';

class GameManager{

   static bool initialized = false;
   late GameSettings _gameSettings;

   static initialize(){
     if(!initialized) {
       Repository.startUp();
       initialized = true;
     }
   }

   void launchGame(BuildContext context,{required GameSettings gameSettings}){
     _gameSettings = gameSettings;
     if(!initialized){
       throw Exception("game not initialized, please call [GameManager.initialize] first");
     }
     launchNewScreen(context, GameHome(_gameSettings));
   }

   ThemeData _getTheme(BuildContext context){
      return Theme.of(context).copyWith(
       textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
       )
      );
   }
 }