import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ios_vision_kit_platform_interface.dart';

/// An implementation of [FlutterIosVisionKitPlatform] that uses method channels.
class MethodChannelFlutterIosVisionKit extends FlutterIosVisionKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ios_vision_kit');

  @override
  Future<bool> validateImageFaceDetection(Uint8List imageData) async {
    dynamic faceDetectionResult;

    try {
      faceDetectionResult = await methodChannel.invokeMethod(
        'validateImageFaceDetection',
        imageData,
      );
    } catch (e) {
      if (e is PlatformException && e.code == 'can_not_run_on_simulator') {
        throw UnimplementedError(
          'The plugin is not implemented for the iOS simulator.',
        );
      }
    }

    if (faceDetectionResult is Map) {
      final hasDetectedFace = faceDetectionResult['isFaceDetected'];
      final errorMessage = faceDetectionResult['errorMessage'];

      if (hasDetectedFace is bool) {
        return hasDetectedFace;
      } else {
        throw PlatformException(
          code: 'FACE_DETECTION_ERROR',
          message: errorMessage,
        );
      }
    }

    throw PlatformException(
      code: 'FACE_DETECTION_ERROR',
      message: 'Could not validate plugin result.',
    );
  }
}
