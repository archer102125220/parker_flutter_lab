# Parker Flutter Lab

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

這是由 [Very Good CLI][very_good_cli_link] 🤖 產生的專案。

一個由 Very Good CLI 建立的 Very Good 專案。

[**English Version**](README.md)

---

## 開始使用 🚀

本專案包含 3 個版本 (flavors)：

- development (開發版)
- staging (測試版)
- production (正式版)

要執行所需的版本，可以使用 VSCode/Android Studio 中的啟動設定，或是使用以下指令：

```sh
# 開發版 (Development)
$ flutter run --flavor development --target lib/main_development.dart

# 測試版 (Staging)
$ flutter run --flavor staging --target lib/main_staging.dart

# 正式版 (Production)
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Parker Flutter Lab 支援 iOS, Android, Web, 和 Windows。_

---

## 執行測試 🧪

要執行所有單元測試 (unit tests) 和小部件測試 (widget tests)，請使用以下指令：

```sh
$ very_good test --coverage --test-randomize-ordering-seed random
```

要查看產生的覆蓋率報告，你可以使用 [lcov](https://github.com/linux-test-project/lcov)。

```sh
# 產生覆蓋率報告
$ genhtml coverage/lcov.info -o coverage/

# 開啟覆蓋率報告
$ open coverage/index.html
```

---

## 處理翻譯 🌐

本專案依賴 [flutter_localizations][flutter_localizations_link] 並遵循 [Flutter 官方國際化指南][internationalization_link]。

### 新增字串

1. 要新增一個新的可定位字串，請開啟位於 `lib/l10n/arb/app_en.arb` 的 `app_en.arb` 檔案。

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. 然後新增一個新的鍵/值 (key/value) 和描述

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. 使用新字串

```dart
import 'package:parker_flutter_lab/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### 新增支援的語言 (Locales)

更新 `ios/Runner/Info.plist` 中的 `CFBundleLocalizations` 陣列以包含新的語言。

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### 新增翻譯

1. 為每個支援的語言，在 `lib/l10n/arb` 中新增一個新的 ARB 檔案。

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. 將翻譯後的字串新增到每個 `.arb` 檔案中：

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### 產生翻譯

要使用最新的翻譯變更，你需要產生它們：

1. 為目前的專案產生本地化檔案：

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

或者，執行 `flutter run`，程式碼產生將會自動進行。

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
