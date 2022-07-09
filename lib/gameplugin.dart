
export 'package:gameplugin/src/game_manager.dart';
export 'package:gameplugin/src/settings/game_settings.dart';
export 'package:gameplugin/src/settings/ball_shape.dart';
export 'package:gameplugin/src/settings/ball_count.dart';
export 'package:gameplugin/src/settings/game_speed.dart';
import 'gameplugin_platform_interface.dart';

class Gameplugin {
  Future<String?> getPlatformVersion() {
    return GamepluginPlatform.instance.getPlatformVersion();
  }
}
