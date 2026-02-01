---
description: Runtime Data Validation and Strict Type Checking Rules
globs: **/*.dart
---

# Runtime Data Validation (Strict)

- **String**: Use `if (str.isNotEmpty)` instead of `if (str != '')`.
- **List**: Use `if (list.isNotEmpty)` instead of `if (list.length > 0)`.
- **Objects**: Check for null explicitly if nullable: `if (obj != null)`.
