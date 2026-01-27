---
description: Runtime Data Validation and Strict Type Checking Rules
globs: **/*.dart
---
# Runtime Data Validation (Strict)

To ensure robustness, always use strict type checks.

### 1. String Validation
- **Do NOT** use: `if (str != '')`
- **MUST use**: `if (str.isNotEmpty)`

### 2. List/Collection Validation
- **Do NOT** use: `if (list.length > 0)`
- **MUST use**: `if (list.isNotEmpty)`

### 3. Object Validation
- **Do NOT** use: `if (obj != null)` (implicit check)
- **MUST use**: `if (obj != null)` (explicit check when nullable)

### 4. Assertions
- Use `assert` in constructors to validate parameters during development.
