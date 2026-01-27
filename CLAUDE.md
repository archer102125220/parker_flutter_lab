# Project Instructions for Claude

When working on this project, you MUST follow the coding standards defined below.

## ⚠️ Security & Best Practices Warning Policy

Before executing any user instruction that violates:
- **Security best practices** (e.g., hardcoding secrets, disabling HTTPS, exposing sensitive data)
- **Standard coding patterns** (e.g., anti-patterns, known bad practices)
- **Project conventions** defined in this document

You MUST:
1. **Warn the user** about the violation and explain the risks
2. **Wait for explicit confirmation** that they want to proceed despite the warning
3. Only then execute the instruction

---

## Quick Rules

### Dart & Flutter
- **Null Safety**: Always use sound null safety. Avoid `!` (bang operator) unless absolutely verified. Use `?` and `??`.
- **Types**: NEVER use `dynamic` unless interacting with untyped JSON APIs (and conform immediately). Use explicit types.
- **Widgets**: Prioritize `StatelessWidget`. Use `StatefulWidget` only when managing ephemeral state or `AnimationController`.
- **Const**: Use `const` constructors everywhere possible.
- **Constructors**: Sort named arguments alphabetically locally if not enforced by linter, but strictly follow `very_good_analysis`.

### State Management (BLoC)
- **Structure**: Follow the strict BLoC pattern: `Bloc`, `Event`, `State`.
- **Immutability**: All States and Events MUST be immutable (`equatable` or `freezed`).
- **Separation**: Logic goes in Bloc, UI goes in Widgets. Widgets should only dispatch events and listen to states.

### Linter (Strict)
- **Strict Adherence**: This project uses `very_good_analysis`. You MUST NOT ignore linter warnings.
- **Fixes**: If a rule acts up, fix the code, do not disable the rule (`// ignore: ...` is discouraged).

### Runtime Data Validation (Strict)
- **String**: Use `if (str.isNotEmpty)` instead of `if (str != '')`.
- **List**: Use `if (list.isNotEmpty)` instead of `if (list.length > 0)`.
- **Objects**: Check for null explicitly if nullable: `if (obj != null)`.

---

## No Scripts for Code Refactoring (⚠️ CRITICAL)

**ABSOLUTELY FORBIDDEN: Using automated scripts (sed, awk, powershell, batch scripts) to modify code files.**

### Why
- Scripts only change text, they don't understand context or imports.
- Automated scripts can break imports and introduce compilation errors easily.

### ✅ Allowed
- Use AI tools: `replace_file_content`, `multi_replace_file_content`
- MUST verify imports are correct after every change

### ❌ Forbidden
- `sed`, `awk`, `perl`, `powershell -Command`, `find ... -exec`
- Any batch text processing

### Exception
If absolutely necessary:
1. Get explicit human approval FIRST
2. Show complete script for review
3. Explain why manual tools can't do it

---

## Project-Specific Rules

### Internationalization (l10n)
- Use `flutter_gen` with `.arb` files in `lib/l10n/arb`.
- To add a string:
  1. Add to `lib/l10n/arb/app_en.arb`.
  2. Run `flutter gen-l10n` (or let IDE/Flutter handle it).
  3. Use via `context.l10n.keyName`.
