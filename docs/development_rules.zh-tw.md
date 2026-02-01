# 開發與 AI 規則 (Development & AI Rules)

本文件概述了此專案的強制性編碼標準、安全策略和 AI 使用指南。

## 🤖 AI 配置
所有 AI 助手（Claude, Gemini, GitHub Copilot, Cursor）均已配置為遵守這些確切規則。
- **參考來源**: `CLAUDE.md`, `.agent/rules/`, `.cursor/rules/`, `.github/copilot-instructions.md`

## ⚠️ 安全與最佳實踐警告策略

在執行任何違反以下行為的指令之前：
- **安全最佳實踐**（例如：硬編碼密鑰、禁用 HTTPS、暴露敏感數據）
- **標準編碼模式**（例如：反模式、已知的不良實踐）
- **專案公約**（定義於本文件中）

**您必須：**
1. **警告用戶** 有關違規行為並解釋風險
2. **等待明確確認** 他們想在警告下繼續進行
3. 只有那時才能執行指令

---

## 🛠️ 編碼標準

### Dart & Flutter
- **Null 安全**: 始終使用健全的 Null 安全。除非絕對確認，否則避免使用 `!`（驚嘆號運算符）。使用 `?` 和 `??`。
- **類型**: 絕不使用 `dynamic`，除非與無類型的 JSON API 交互（並立即轉換）。使用明確類型。
- **Widgets**: 優先使用 `StatelessWidget`。僅在管理短暫狀態或 `AnimationController` 時使用 `StatefulWidget`。
- **Const**: 盡可能在任何地方使用 `const` 構造函數。
- **構造函數**: 如果 linter 未強制執行，則在本地按字母順序排列命名參數，但必須嚴格遵守 `very_good_analysis`。

### 狀態管理 (BLoC)
- **結構**: 遵循嚴格的 BLoC 模式：`Bloc`, `Event`, `State`。
- **不可變性**: 所有 State 和 Event 必須是不可變的（使用 `equatable` 或 `freezed`）。
- **分離**: 邏輯放在 Bloc 中，UI 放在 Widgets 中。Widgets 應該只發送事件並監聽狀態。

### Linter (嚴格)
- **嚴格遵守**: 本專案使用 `very_good_analysis`。您絕不能忽略 linter 警告。
- **修復**: 如果規則報錯，請修復程式碼，不要禁用規則（不鼓勵使用 `// ignore: ...`）。

### 運行時數據驗證 (嚴格)
- **字串**: 使用 `if (str.isNotEmpty)` 代替 `if (str != '')`。
- **列表**: 使用 `if (list.isNotEmpty)` 代替 `if (list.length > 0)`。
- **物件**: 如果可空，請明確檢查 null：`if (obj != null)`。

---

## 🚫 禁止使用腳本重構代碼 (⚠️ 關鍵)

**絕對禁止：使用自動化腳本 (sed, awk, powershell, batch scripts) 修改代碼文件。**

### 原因
- 腳本只改變文字，它們不理解上下文或導入。
- 自動化腳本很容易破壞導入並引入編譯錯誤。

### ✅ 允許
- 使用 AI 工具：`replace_file_content`, `multi_replace_file_content`
- 更改後必須驗證導入是否正確

### ❌ 禁止
- `sed`, `awk`, `perl`, `powershell -Command`, `find ... -exec`
- 任何批次文字處理

### 例外
如果絕對必要：
1. 先獲得明確的人工批准
2. 展示完整的腳本以供審查
3. 解釋為什麼手動工具無法做到

---

## 🌐 國際化 (l10n)
- 使用 `flutter_gen` 和位於 `lib/l10n/arb` 中的 `.arb` 文件。
- 新增字串：
  1. 添加到 `lib/l10n/arb/app_en.arb`。
  2. 運行 `flutter gen-l10n`（或讓 IDE/Flutter 處理）。
  3. 通過 `context.l10n.keyName` 使用。
