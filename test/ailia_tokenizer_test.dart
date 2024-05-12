import 'package:flutter_test/flutter_test.dart';
import 'package:ailia_tokenizer/ailia_tokenizer.dart';
import 'package:ailia_tokenizer/ailia_tokenizer_platform_interface.dart';
import 'package:ailia_tokenizer/ailia_tokenizer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAiliaTokenizerPlatform
    with MockPlatformInterfaceMixin
    implements AiliaTokenizerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AiliaTokenizerPlatform initialPlatform = AiliaTokenizerPlatform.instance;

  test('$MethodChannelAiliaTokenizer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAiliaTokenizer>());
  });

  test('getPlatformVersion', () async {
    AiliaTokenizer ailiaTokenizerPlugin = AiliaTokenizer();
    MockAiliaTokenizerPlatform fakePlatform = MockAiliaTokenizerPlatform();
    AiliaTokenizerPlatform.instance = fakePlatform;

    expect(await ailiaTokenizerPlugin.getPlatformVersion(), '42');
  });
}
