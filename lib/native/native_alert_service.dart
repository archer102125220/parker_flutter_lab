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
