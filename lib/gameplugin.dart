
export 'package:gameplugin/src/game_manager.dart';
export 'package:gameplugin/src/models/game_settings.dart';
export 'package:gameplugin/src/models/ball_shape.dart';
export 'package:gameplugin/src/models/ball_count.dart';
export 'package:gameplugin/src/models/game_speed.dart';
export 'package:gameplugin/src/models/game_instruction.dart';
export 'package:gameplugin/src/models/game_mode.dart';
import 'gameplugin_platform_interface.dart';

class Gameplugin {
  Future<String?> getPlatformVersion() {
    return GamepluginPlatform.instance.getPlatformVersion();
  }
}
