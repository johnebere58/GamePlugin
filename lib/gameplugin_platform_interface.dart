import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gameplugin_method_channel.dart';

abstract class GamepluginPlatform extends PlatformInterface {
  /// Constructs a GamepluginPlatform.
  GamepluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static GamepluginPlatform _instance = MethodChannelGameplugin();

  /// The default instance of [GamepluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelGameplugin].
  static GamepluginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GamepluginPlatform] when
  /// they register themselves.
  static set instance(GamepluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
