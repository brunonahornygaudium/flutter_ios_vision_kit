import 'dart:typed_data';

import 'package:flutter_ios_vision_kit/flutter_ios_vision_kit.dart';
import 'package:flutter_ios_vision_kit/flutter_ios_vision_kit_method_channel.dart';
import 'package:flutter_ios_vision_kit/flutter_ios_vision_kit_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterIosVisionKitPlatform
    with MockPlatformInterfaceMixin
    implements FlutterIosVisionKitPlatform {
  @override
  Future<bool> validateImageFaceDetection(Uint8List imageData) {
    // TODO: implement validateImageFaceDetection
    throw UnimplementedError();
  }
}

void main() {
  final FlutterIosVisionKitPlatform initialPlatform =
      FlutterIosVisionKitPlatform.instance;

  test('$MethodChannelFlutterIosVisionKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterIosVisionKit>());
  });

  test('getPlatformVersion', () async {
    FlutterIosVisionKit flutterIosVisionKitPlugin = FlutterIosVisionKit();
    MockFlutterIosVisionKitPlatform fakePlatform =
        MockFlutterIosVisionKitPlatform();
    FlutterIosVisionKitPlatform.instance = fakePlatform;

    // expect(await flutterIosVisionKitPlugin.getPlatformVersion(), '42');
  });
}
