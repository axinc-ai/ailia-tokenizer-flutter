import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ailia_tokenizer/ailia_tokenizer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAiliaTokenizer platform = MethodChannelAiliaTokenizer();
  const MethodChannel channel = MethodChannel('ailia_tokenizer');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
