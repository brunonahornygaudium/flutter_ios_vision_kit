class FaceDetectionResult {
  final bool isFaceDetected;
  final String? errorMessage;

  FaceDetectionResult({
    required this.isFaceDetected,
    this.errorMessage,
  });
}
