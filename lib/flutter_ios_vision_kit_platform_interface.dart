import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ios_vision_kit_method_channel.dart';

abstract class FlutterIosVisionKitPlatform extends PlatformInterface {
  /// Constructs a FlutterIosVisionKitPlatform.
  FlutterIosVisionKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterIosVisionKitPlatform _instance =
      MethodChannelFlutterIosVisionKit();

  /// The default instance of [FlutterIosVisionKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterIosVisionKit].
  static FlutterIosVisionKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterIosVisionKitPlatform] when
  /// they register themselves.
  static set instance(FlutterIosVisionKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> validateImageFaceDetection(Uint8List imageData) {
    throw UnimplementedError(
        'validateImageFaceDetection() has not been implemented.');
  }
}
