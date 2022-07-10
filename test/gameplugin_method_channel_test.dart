import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameplugin/gameplugin_method_channel.dart';

void main() {
  MethodChannelGameplugin platform = MethodChannelGameplugin();
  const MethodChannel channel = MethodChannel('gameplugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
