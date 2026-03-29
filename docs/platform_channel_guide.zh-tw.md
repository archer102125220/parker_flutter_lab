# Flutter Platform Channel 原生功能整合指南

> 本文說明如何在 `parker_flutter_lab` 中，透過 **Platform Channel（MethodChannel）** 讓 Dart 程式碼呼叫各平台的原生功能。
> 以「顯示原生提示 Alert Dialog」為實作示範。

---

## 目錄

1. [概念說明](#概念說明)
2. [架構圖](#架構圖)
3. [實作步驟](#實作步驟)
   - [步驟 1：定義 Channel 名稱（命名規則）](#步驟-1定義-channel-名稱命名規則)
   - [步驟 2：Dart 端 — 建立 Service 類別](#步驟-2dart-端--建立-service-類別)
   - [步驟 3：Android 端 — Kotlin 實作](#步驟-3android-端--kotlin-實作)
   - [步驟 4：iOS 端 — Swift 實作](#步驟-4ios-端--swift-實作)
   - [步驟 5：在 Widget 中呼叫](#步驟-5在-widget-中呼叫)
4. [專案檔案結構](#專案檔案結構)
5. [常見問題](#常見問題)
6. [延伸閱讀](#延伸閱讀)

---

## 概念說明

Flutter 的 **Platform Channel** 是一套訊息傳遞機制，讓 Dart（Flutter）與原生平台（Android / iOS）之間互相溝通。

| 元件 | 說明 |
|------|------|
| `MethodChannel` | 最常用；Dart 呼叫原生方法，可帶參數、接收回傳值 |
| `EventChannel` | 原生端持續推送資料流給 Dart（如感測器） |
| `BasicMessageChannel` | 雙向傳遞任意訊息（字串 / 二進位） |

本示範使用 `MethodChannel`。

---

## 架構圖

```
┌─────────────────────────────────────────────────────────────┐
│                        Flutter (Dart)                        │
│                                                              │
│   NativeAlertService                                         │
│   └── MethodChannel('com.example.parker_flutter_lab/alert')  │
│       └── invokeMethod('showAlert', { title, message })      │
└───────────────────────────┬─────────────────────────────────┘
                            │  Platform Channel (訊息序列化)
           ┌────────────────┴────────────────┐
           ▼                                 ▼
┌─────────────────────┐           ┌──────────────────────┐
│   Android (Kotlin)  │           │    iOS (Swift)         │
│   MainActivity.kt   │           │    AppDelegate.swift   │
│   AlertDialog       │           │    UIAlertController   │
└─────────────────────┘           └──────────────────────┘
```

---

## 實作步驟

### 步驟 1：定義 Channel 名稱（命名規則）

Channel 名稱採用**反向 DNS + 功能描述**，保證全域唯一：

```
com.example.parker_flutter_lab/alert
│────────────────────────────│ │────│
       套件識別碼（App ID）      功能名稱
```

> ⚠️ Dart 端、Android 端、iOS 端三方的字串必須**完全一致**，否則呼叫會失敗並拋出 `MissingPluginException`。

---

### 步驟 2：Dart 端 — 建立 Service 類別

**檔案位置：** `lib/native/native_alert_service.dart`

```dart
import 'package:flutter/services.dart';

/// 原生提示訊息服務，透過 MethodChannel 呼叫各平台原生的 Alert Dialog。
///
/// - Android：使用 AlertDialog（Kotlin）
/// - iOS：使用 UIAlertController（Swift）
class NativeAlertService {
  const NativeAlertService();

  static const _channel = MethodChannel('com.example.parker_flutter_lab/alert');

  /// 呼叫原生提示訊息。
  ///
  /// [title] 是對話框標題，[message] 是對話框內文。
  /// 若平台不支援，會擲出 [MissingPluginException]。
  Future<void> showAlert({
    required String title,
    required String message,
  }) async {
    await _channel.invokeMethod<void>(
      'showAlert',
      <String, String>{
        'title': title,
        'message': message,
      },
    );
  }
}
```

並建立 barrel file `lib/native/native.dart`：

```dart
export 'native_alert_service.dart';
```

**重點說明：**
- `MethodChannel` 宣告為 `static const`，避免重複建立物件。
- 傳遞參數使用 `Map<String, String>`，對應原生端解析方式。
- `invokeMethod<void>` 泛型指定回傳型別，提升型別安全性。

---

### 步驟 3：Android 端 — Kotlin 實作

**檔案位置：** `android/app/src/main/kotlin/…/MainActivity.kt`

```kotlin
package com.example.verygoodcore.parker_flutter_lab

import android.app.AlertDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.example.parker_flutter_lab/alert"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "showAlert" -> {
                    val title = call.argument<String>("title") ?: "提示"
                    val message = call.argument<String>("message") ?: ""
                    showNativeAlert(title, message)
                    result.success(null)  // 通知 Dart 呼叫成功
                }
                else -> result.notImplemented()  // 未知方法
            }
        }
    }

    private fun showNativeAlert(title: String, message: String) {
        AlertDialog.Builder(this)
            .setTitle(title)
            .setMessage(message)
            .setPositiveButton("確定") { dialog, _ -> dialog.dismiss() }
            .show()
    }
}
```

**重點說明：**
- `configureFlutterEngine` 是 Flutter Engine 初始化的 hook，在此處註冊 Channel。
- `call.argument<String>("key")` 取得 Dart 傳入的參數，加 `?: "預設值"` 防止 null。
- 必須呼叫 `result.success()` 或 `result.error()` 或 `result.notImplemented()`，否則 Dart 端會永久等待。

---

### 步驟 4：iOS 端 — Swift 實作

**檔案位置：** `ios/Runner/AppDelegate.swift`

```swift
import UIKit
import Flutter

@UIApplicationMain
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
      result(nil)  // 通知 Dart 呼叫成功
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

**重點說明：**
- `FlutterViewController` 提供 `binaryMessenger`，是 iOS 端 Channel 的通訊橋。
- Closure 中使用 `[weak controller]` 避免 retain cycle。
- `result(FlutterMethodNotImplemented)` 對應未知方法，與 Android 的 `notImplemented()` 等效。

---

### 步驟 5：在 Widget 中呼叫

```dart
import 'package:parker_flutter_lab/native/native.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  // 宣告為 static const，整個 Widget tree 共用同一實例
  static const _alertService = NativeAlertService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'native_alert_btn',
        onPressed: () async {
          await _alertService.showAlert(
            title: '原生提示',
            message: '這是透過 Platform Channel 呼叫的原生 Alert！',
          );
        },
        icon: const Icon(Icons.notifications_active),
        label: const Text('原生提示'),
      ),
    );
  }
}
```

---

## 專案檔案結構

```
parker_flutter_lab/
├── lib/
│   ├── native/
│   │   ├── native.dart                  # Barrel export
│   │   └── native_alert_service.dart    # Dart 端 MethodChannel 封裝
│   └── counter/
│       └── view/
│           └── counter_page.dart        # 呼叫點（示範按鈕）
├── android/
│   └── app/src/main/kotlin/.../
│       └── MainActivity.kt              # Android 原生端實作
└── ios/
    └── Runner/
        └── AppDelegate.swift            # iOS 原生端實作
```

---

## 常見問題

### 呼叫後沒有反應 / `MissingPluginException`

- 確認 Channel 名稱三端（Dart / Android / iOS）完全一致，包含大小寫。
- 確認 `configureFlutterEngine`（Android）或 `didFinishLaunchingWithOptions`（iOS）中已正確呼叫 `setMethodCallHandler`。
- 如使用 `flutter run`，請確認已儲存並 hot-restart（非 hot-reload），原生端變更需完整重新啟動。

### 傳遞複雜型別

Platform Channel 支援的資料型別（StandardMessageCodec）：

| Dart 型別 | Android 型別 | iOS 型別 |
|-----------|-------------|---------|
| `bool` | `Boolean` | `Bool` |
| `int` | `Int` / `Long` | `Int` / `Int64` |
| `double` | `Double` | `Double` |
| `String` | `String` | `String` |
| `Uint8List` | `byte[]` | `FlutterStandardTypedData` |
| `List` | `ArrayList` | `Array` |
| `Map` | `HashMap` | `Dictionary` |

不支援自訂物件，需手動序列化成 `Map`。

### 在 UI Thread 更新畫面

Android 的 `setMethodCallHandler` 預設在主執行緒運行；若有耗時操作，請手動切換：

```kotlin
Handler(Looper.getMainLooper()).post {
    // 更新 UI
}
```

---

## 延伸閱讀

- [Flutter 官方文件 — Writing custom platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels)
- [Pigeon](https://pub.dev/packages/pigeon)：Flutter 官方的型別安全 Platform Channel 程式碼產生工具，適合大型專案
- [flutter_platform_interface](https://pub.dev/packages/plugin_platform_interface)：建立可跨平台複用 Plugin 的標準接口規範
