import 'dart:typed_data';

import 'flutter_ios_vision_kit_platform_interface.dart';

class FlutterIosVisionKit {
  Future<bool> validateImageFaceDetection(Uint8List imageData) {
    return FlutterIosVisionKitPlatform.instance
        .validateImageFaceDetection(imageData);
  }
}
