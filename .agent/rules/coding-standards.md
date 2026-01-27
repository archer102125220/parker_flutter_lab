---
description: Project coding standards and conventions
globs: ["**/*.dart"]
alwaysApply: true
---

# Project Coding Standards

## Dart & Flutter
- **Null Safety**: Always use sound null safety. Avoid `!` (bang operator). Use `?` and `??`.
- **Types**: NEVER use `dynamic`. Use explicit types.
- **Widgets**: Prioritize `StatelessWidget`. Use `StatefulWidget` only when managing ephemeral state or `AnimationController`.
- **Const**: Use `const` constructors everywhere possible.
- **Linter**: Follow `very_good_analysis` strictly.

## State Management (BLoC)
- **Structure**: `Bloc`, `Event`, `State`.
- **Immutability**: All States and Events MUST be immutable (`equatable` or `freezed`).
- **Separation**: Logic in Bloc; UI in Widgets.

## Internationalization (l10n)
- Use `context.l10n` for all user-facing strings.
- Add new strings to `lib/l10n/arb/app_en.arb`.
