import UIKit
import Flutter
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
  private let channelName = "com.example/tracking"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let trackingChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)

    trackingChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "requestTrackingAuthorization" {
        if #available(iOS 14.0, *) {
          ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
              result("Tracking authorization not determined")
            case .restricted:
              result("Tracking authorization restricted")
            case .denied:
              result("Tracking authorization denied")
            case .authorized:
              result("Tracking authorization authorized")
            @unknown default:
              result("Unknown tracking authorization status")
            }
          }
        } else {
          result("iOS version not supported")
        }
      } else if call.method == "getTrackingAuthorizationStatus" {
        if #available(iOS 14.0, *) {
          let status = ATTrackingManager.trackingAuthorizationStatus
          switch status {
          case .notDetermined:
            result("notDetermined")
          case .restricted:
            result("restricted")
          case .denied:
            result("denied")
          case .authorized:
            result("authorized")
          @unknown default:
            result("unknown")
          }
        } else {
          result("unsupported")
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
