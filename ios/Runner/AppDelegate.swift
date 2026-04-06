import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let channelName = "com.example.parker_flutter_lab/alert"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    guard let controller = window?.rootViewController as? FlutterViewController else {
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    let alertChannel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: controller.binaryMessenger
    )

    alertChannel.setMethodCallHandler { [weak controller] call, result in
      guard call.method == "showAlert" else {
        result(FlutterMethodNotImplemented)
        return
      }

      let args = call.arguments as? [String: String]
      let title = args?["title"] ?? "提示"
      let message = args?["message"] ?? ""

      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "確定", style: .default))

      controller?.present(alert, animated: true)
      result(nil)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
