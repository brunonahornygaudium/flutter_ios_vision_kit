import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ios_vision_kit/flutter_ios_vision_kit.dart';
import 'package:image/image.dart' as image;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _hasDetectedFace;
  String? _errorMessage;
  final _flutterIosVisionKitPlugin = FlutterIosVisionKit();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> validateFoto(String assetPath) async {
    bool? hasDetectedFace;
    String? errorMessage;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.

    try {
      final ByteData data = await rootBundle.load(assetPath);

      // Decode the image
      image.Image? imageJpeg = image.decodeImage(data.buffer.asUint8List());

      if (imageJpeg != null) {
        // Get the larger side (width or height)
        int maxSide = 300;
        int width = imageJpeg.width;
        int height = imageJpeg.height;

        // Calculate new dimensions while maintaining the aspect ratio
        if (width > height) {
          imageJpeg = image.copyResize(imageJpeg, width: maxSide);
        } else {
          imageJpeg = image.copyResize(imageJpeg, height: maxSide);
        }

        // Encode as JPEG
        List<int> jpegBytes = image.encodeJpg(imageJpeg);

        hasDetectedFace = await _flutterIosVisionKitPlugin
            .validateImageFaceDetection(Uint8List.fromList(jpegBytes));
      }
    } on PlatformException catch (e) {
      errorMessage = e.message ?? 'Failed to validate photo.';
    } on UnimplementedError catch (e) {
      errorMessage = e.message ?? 'Não está disponível para essa plataforma.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _hasDetectedFace = hasDetectedFace;
      _errorMessage = errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                children: [
                  ImagePicker(
                    assetPath: 'assets/a_beautiful_guy.jpg',
                    onImageSelected: (path) => validateFoto(path),
                  ),
                  ImagePicker(
                    assetPath: 'assets/ilustration_passenger.png',
                    onImageSelected: (path) => validateFoto(path),
                  ),
                ],
              ),
              Builder(
                builder: (BuildContext context) {
                  if (_errorMessage != null) {
                    return Text('$_errorMessage');
                  }

                  if (_hasDetectedFace == null) {
                    return const Text('Escolha uma foto para validar.');
                  }

                  final message = _hasDetectedFace!
                      ? 'Face detectada!'
                      : 'Face não detectada.';

                  return Text(message);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePicker extends StatelessWidget {
  final String assetPath;
  final Function(String) onImageSelected;

  const ImagePicker({
    super.key,
    required this.assetPath,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onImageSelected(assetPath);
      },
      child: Image.asset(
        assetPath,
        width: 100,
      ),
    );
  }
}
