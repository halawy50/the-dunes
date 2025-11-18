# THE DUNES ERP System - Project Rules

This document defines the **MANDATORY** rules that all code in this project must follow.

## 🚨 CRITICAL RULES

### Rule 1: File Length Limit - 100 Lines Maximum

**ABSOLUTE RULE: NO file in the project should exceed 100 lines.**

This applies to:
- ✅ Screens (`screens/`)
- ✅ Widgets (`widgets/`)
- ✅ Cubits (`cubits/`)
- ✅ Models (`models/`)
- ✅ Repositories (`repositories/`)
- ✅ Data Sources (`datasources/`)
- ✅ Use Cases (`usecases/`)
- ✅ Entities (`entities/`)
- ✅ Any other Dart file

**When a file exceeds 100 lines:**
1. **IMMEDIATELY** split it into smaller files
2. Follow Clean Architecture principles
3. Extract logic to appropriate layers

**Splitting Strategies:**

#### For Screens:
```dart
// ❌ WRONG - 120 lines
analysis_screen.dart (120 lines)

// ✅ CORRECT - Split into:
analysis_screen.dart (50 lines)
widgets/
  analysis_header_widget.dart (40 lines)
  analysis_content_widget.dart (45 lines)
  analysis_footer_widget.dart (35 lines)
```

#### For Models:
```dart
// ❌ WRONG - 150 lines
permissions_model.dart (150 lines)

// ✅ CORRECT - Split into:
permissions_model.dart (50 lines)
permissions_factory.dart (40 lines)
permissions_json_helper.dart (60 lines)
```

#### For Cubits:
```dart
// ❌ WRONG - 120 lines
login_cubit.dart (120 lines)

// ✅ CORRECT - Split into:
login_cubit.dart (60 lines)
login_state.dart (50 lines)
```

---

### Rule 2: Zero Hardcoded Text - Complete Internationalization

**ABSOLUTE RULE: NO hardcoded text strings anywhere in the codebase.**

This includes:
- ✅ UI text (buttons, labels, titles, subtitles)
- ✅ Error messages
- ✅ Exception messages
- ✅ Validation messages
- ✅ Placeholder text
- ✅ Log messages (if user-facing)
- ✅ Any string visible to users

**Translation Requirements:**
1. **ALL** text must be translated
2. **ALL** translations must be added to **ALL 6 language files**:
   - `assets/translations/en.json`
   - `assets/translations/ar.json`
   - `assets/translations/ru.json`
   - `assets/translations/hi.json`
   - `assets/translations/de.json`
   - `assets/translations/es.json`

**Translation Key Structure:**
```
feature.section.key
```

Examples:
- `login.error.invalid_credentials`
- `navbar.analysis.title`
- `common.user`
- `errors.connection_failed`

**Implementation Steps:**
1. **BEFORE** writing code with text:
   - Add translation key to ALL 6 language files
   - Use `.tr()` extension in code

2. **Example:**
```dart
// ❌ WRONG - Hardcoded text
Text('Welcome to Dashboard')
throw ApiException(message: 'Connection failed')
AppSnackbar.show(message: 'Login successful!')

// ✅ CORRECT - Translated text
// Step 1: Add to ALL translation files
// en.json: "dashboard.welcome": "Welcome to Dashboard"
// ar.json: "dashboard.welcome": "مرحباً بك في لوحة التحكم"
// ru.json: "dashboard.welcome": "Добро пожаловать в панель управления"
// hi.json: "dashboard.welcome": "डैशबोर्ड में आपका स्वागत है"
// de.json: "dashboard.welcome": "Willkommen im Dashboard"
// es.json: "dashboard.welcome": "Bienvenido al Panel"

// Step 2: Use in code
Text('dashboard.welcome'.tr())
throw ApiException(message: 'errors.connection_failed'.tr())
AppSnackbar.show(message: 'login.success'.tr())
```

**Special Cases:**
- API error messages: Use translation keys in `ApiException`
- Network errors: Use `errors.*` translation keys
- Validation messages: Use `validation.*` translation keys

---

### Rule 3: Clean Architecture Compliance

**MUST** strictly follow Clean Architecture with clear layer separation:

```
features/
  feature_name/
    data/              # Data Layer
      datasources/    # Remote/Local data sources
      models/         # Data models (JSON serializable)
      repositories/   # Repository implementations
    domain/           # Domain Layer (Business Logic)
      entities/       # Business objects (pure Dart)
      repositories/   # Repository interfaces (abstract)
      usecases/       # Business logic (single responsibility)
    presentation/     # Presentation Layer
      cubits/         # State management
      screens/        # Screen widgets (< 100 lines)
      widgets/        # Reusable widgets (< 100 lines)
```

**Layer Rules:**
- ✅ Domain layer: **NO** imports from data or presentation
- ✅ Data layer: Can import domain only
- ✅ Presentation layer: Can import domain and data
- ✅ **NEVER** mix layers

**Dependency Injection:**
- ✅ **ALL** dependencies must use GetIt
- ✅ Register in `injection_container.dart`
- ✅ Use interfaces in domain, implementations in data

---

### Rule 4: State Management

**MUST** use Cubit (flutter_bloc) for state management:

- ✅ Use `Cubit` for state management
- ✅ Use `StatelessWidget` when possible
- ✅ Register all Cubits in `injection_container.dart`
- ✅ Use `BlocProvider`, `BlocListener`, `BlocBuilder` pattern
- ✅ Separate state classes to `*_state.dart` files if > 100 lines

---

### Rule 5: Code Organization

**MUST** follow this structure:

1. **Features**: Each feature in its own folder
2. **Separation**: Screens, widgets, cubits in separate files
3. **Naming**: Meaningful file and class names
4. **Structure**: Follow existing folder structure

---

## Code Review Checklist

Before submitting any code, verify:

- [ ] **NO file exceeds 100 lines** (check ALL files)
- [ ] **ALL text is translated** (no hardcoded strings)
- [ ] **ALL translations added to ALL 6 language files**
- [ ] Clean Architecture structure followed
- [ ] Layers are not mixed
- [ ] Cubit used for state management
- [ ] Dependencies registered in `injection_container.dart`
- [ ] Routes added to `app_router.dart` if needed
- [ ] RTL support considered for Arabic
- [ ] Files split if they exceed 100 lines

---

## Enforcement

These rules are **MANDATORY** and **NON-NEGOTIABLE**.

Any code violating these rules will be:
1. ❌ Rejected immediately
2. 🔄 Required to be refactored
3. ✅ Must pass all checks before acceptance

---

## Quick Reference

### File Length: 100 lines max
### Translations: ALL 6 languages required
### Architecture: Clean Architecture only
### State: Cubit only
### Text: Zero hardcoded strings

---

**Last Updated:** 2024
**Project:** THE DUNES ERP System
**Architecture:** Clean Architecture
**Languages Supported:** en, ar, ru, hi, de, es

