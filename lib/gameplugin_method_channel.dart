import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gameplugin_platform_interface.dart';

/// An implementation of [GamepluginPlatform] that uses method channels.
class MethodChannelGameplugin extends GamepluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gameplugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
