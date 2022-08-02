
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/src/models/game_mode.dart';

extension GameIdExtension on GameIds{

  String get title =>
      index == 0?"Find Ball" :
      index == 1?"Hidden Bug" :
      "";


  String get description =>
      index == 0?
      "Find the ball with the color as the balls are hidden and shuffled around" :
      index == 1?
      "Find the hidden bug, as the balls are shuffled around" :
      "";

  String get imageAsset =>
      index == 0?"assets/game_images/hidden_bug.png" :
      index == 1?"assets/game_images/hidden_bug.png" :
      "";


}