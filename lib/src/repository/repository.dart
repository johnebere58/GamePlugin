
import 'package:gameplugin/src/blocs/ball_controller.dart';
import 'package:gameplugin/src/blocs/ball_event_controller.dart';
import 'package:gameplugin/src/blocs/end_game_controller.dart';
import 'package:gameplugin/src/blocs/game_settings_controller.dart';
import 'package:gameplugin/src/blocs/pop_single_text_controller.dart';
import 'package:gameplugin/src/blocs/restart_controller.dart';
import 'package:gameplugin/src/blocs/timer_controller.dart';
import 'package:get_it/get_it.dart';

 GetIt getIt = GetIt.instance..allowReassignment = true;

 class Repository{

   static Repository get instance => getIt<Repository>();

   static startUp(){

     getIt.registerSingleton<Repository>(Repository());

     getIt.registerSingleton<BallController>(BallController());

     getIt.registerSingleton<BallEventController>(BallEventController());

     getIt.registerSingleton<PopSingleTextController>(PopSingleTextController());

     getIt.registerSingleton<RestartController>(RestartController());

     getIt.registerSingleton<EndGameController>(EndGameController());

     getIt.registerSingleton<TimerController>(TimerController());

     getIt.registerSingleton<GameSettingsController>(GameSettingsController());

   }

 }