import Flutter
import UIKit
import Vision

public class FlutterIosVisionKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_ios_vision_kit", binaryMessenger: registrar.messenger())
    let instance = FlutterIosVisionKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "validateImageFaceDetection":
      validateImageFaceDetection(call, result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }


  private func validateImageFaceDetection(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    #if targetEnvironment(simulator)
      result(FlutterError(code: "can_not_run_on_simulator", message: "Can not run on Simulator", details: nil))
      return
    #else

    guard let arguments:FlutterStandardTypedData = call.arguments as? FlutterStandardTypedData else {
        result(["errorMessage": "Couldn't find image data"])
        return
    }

    let uintInt8List =  call.arguments as! FlutterStandardTypedData
    let byte = [UInt8](uintInt8List.data)

    // Convert the byte array into Data
    let imageData = Data(byte)
    
    // Create a CGImage from JPEG data
    guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
          let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
        result(["errorMessage": "Unable to create CGImage from JPEG data"])
        return
    }

    // Use VNImageRequestHandler with the CGImage
    let requestHandler = VNImageRequestHandler(cgImage: cgImage)

    let request = VNDetectFaceRectanglesRequest { request, error in
            if error != nil {
                result(["errorMessage": "Unable to perform the requests: \(error)."])
                return
            }

            guard let results = request.results as? [VNFaceObservation], !results.isEmpty else {
                result(["isFaceDetected": false])
                return
            }
            
            result(["isFaceDetected": true])
        }
    
    DispatchQueue.global(qos: .userInitiated).async {
      do {
          try requestHandler.perform([request])
      } catch {
          result(["errorMessage": "Unable to perform the requests: Unknown Error: \(error)."])
      }
    }
    #endif
  }
}
