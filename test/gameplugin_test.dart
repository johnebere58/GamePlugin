import 'package:flutter_test/flutter_test.dart';
import 'package:gameplugin/gameplugin.dart';
import 'package:gameplugin/gameplugin_platform_interface.dart';
import 'package:gameplugin/gameplugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGamepluginPlatform 
    with MockPlatformInterfaceMixin
    implements GamepluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GamepluginPlatform initialPlatform = GamepluginPlatform.instance;

  test('$MethodChannelGameplugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGameplugin>());
  });

  test('getPlatformVersion', () async {
    Gameplugin gamepluginPlugin = Gameplugin();
    MockGamepluginPlatform fakePlatform = MockGamepluginPlatform();
    GamepluginPlatform.instance = fakePlatform;
  
    expect(await gamepluginPlugin.getPlatformVersion(), '42');
  });
}
