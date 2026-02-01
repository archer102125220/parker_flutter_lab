---
description: Project coding standards and conventions
globs: ["**/*.dart"]
alwaysApply: true
---

# Project Coding Standards

## Dart & Flutter
- **Null Safety**: Always use sound null safety. Avoid `!` (bang operator) unless absolutely verified. Use `?` and `??`.
- **Types**: NEVER use `dynamic` unless interacting with untyped JSON APIs (and conform immediately). Use explicit types.
- **Widgets**: Prioritize `StatelessWidget`. Use `StatefulWidget` only when managing ephemeral state or `AnimationController`.
- **Const**: Use `const` constructors everywhere possible.
- **Constructors**: Sort named arguments alphabetically locally if not enforced by linter, but strictly follow `very_good_analysis`.

## State Management (BLoC)
- **Structure**: Follow the strict BLoC pattern: `Bloc`, `Event`, `State`.
- **Immutability**: All States and Events MUST be immutable (`equatable` or `freezed`).
- **Separation**: Logic goes in Bloc, UI goes in Widgets. Widgets should only dispatch events and listen to states.

## Linter (Strict)
- **Strict Adherence**: This project uses `very_good_analysis`. You MUST NOT ignore linter warnings.
- **Fixes**: If a rule acts up, fix the code, do not disable the rule (`// ignore: ...` is discouraged).

## Internationalization (l10n)
- Use `flutter_gen` with `.arb` files in `lib/l10n/arb`.
- To add a string:
  1. Add to `lib/l10n/arb/app_en.arb`.
  2. Run `flutter gen-l10n` (or let IDE/Flutter handle it).
  3. Use via `context.l10n.keyName`.
