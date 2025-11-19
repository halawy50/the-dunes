# Clean Architecture Structure

This project follows Clean Architecture principles with the following structure:

## Folder Structure

```
lib/
├── core/                    # Core utilities and shared code
│   ├── app_router/         # GoRouter configuration
│   ├── dependency_injection/  # GetIt setup
│   ├── utils/              # Utility classes
│   └── widgets/            # Shared widgets
│
└── features/               # Feature modules
    └── login/
        ├── data/           # Data layer
        │   ├── models/     # Data models (extend entities)
        │   └── repositories/  # Repository implementations
        │
        ├── domain/         # Domain layer (business logic)
        │   ├── entities/   # Business objects
        │   ├── repositories/  # Repository interfaces
        │   └── usecases/   # Business use cases
        │
        └── persentation/   # Presentation layer (UI)
            ├── cubit/      # State management (Cubit)
            ├── screens/    # UI screens
            └── widgets/    # Feature-specific widgets
```

## Architecture Layers

### 1. Domain Layer (Business Logic)
- **Entities**: Pure business objects (e.g., `UserEntity`)
- **Repositories**: Abstract interfaces (contracts)
- **Use Cases**: Business logic operations

### 2. Data Layer (Data Sources)
- **Models**: Data transfer objects that extend entities
- **Repository Implementations**: Concrete implementations of domain repositories
- **Data Sources**: API clients, local storage, etc.

### 3. Presentation Layer (UI)
- **Cubits**: State management using BLoC pattern
- **Screens**: UI screens/widgets
- **Widgets**: Reusable UI components

## Dependencies Flow

```
Presentation → Domain ← Data
```

- **Presentation depends on Domain** (not on Data)
- **Data depends on Domain** (implements Domain interfaces)
- **Domain is independent** (no dependencies on other layers)

## State Management

We use **Cubit** (from flutter_bloc) for state management:

```dart
// Cubit handles business logic
LoginCubit → calls → LoginUseCase → calls → LoginRepository

// UI listens to state changes
BlocProvider → BlocListener → BlocBuilder
```

## Routing

We use **GoRouter** for navigation:

```dart
// Define routes in app_router.dart
AppRouter.router

// Navigate using:
context.go(AppRouter.login);
context.push(AppRouter.home);
```

## Dependency Injection

We use **GetIt** for dependency injection:

```dart
// Register dependencies in injection_container.dart
sl.registerFactory(() => LoginCubit(sl()));
sl.registerLazySingleton(() => LoginUseCase(sl()));
sl.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());

// Use in code:
final cubit = sl<LoginCubit>();
```

## Adding a New Feature

1. Create folder structure under `features/`
2. Create entities in `domain/entities/`
3. Create repository interface in `domain/repositories/`
4. Create use case in `domain/usecases/`
5. Create model in `data/models/`
6. Create repository implementation in `data/repositories/`
7. Create cubit in `persentation/cubit/`
8. Create screens in `persentation/screens/`
9. Register dependencies in `injection_container.dart`
10. Add routes in `app_router.dart`

## Project Rules & Guidelines

### ⚠️ CRITICAL RULES - MUST FOLLOW

#### 1. File Length Limit
- **NO screen file should exceed 150 lines**
- If a screen exceeds 150 lines, **MUST** split it into smaller widgets
- Extract complex UI sections into separate widget files in `widgets/` folder
- Example: If `analysis_screen.dart` is 200 lines, create:
  - `analysis_screen.dart` (main structure, < 150 lines)
  - `analysis_header_widget.dart`
  - `analysis_content_widget.dart`
  - `analysis_footer_widget.dart`

#### 2. Clean Architecture Compliance
- **MUST** follow Clean Architecture structure:
  - Domain layer: Entities, Repository interfaces, Use cases
  - Data layer: Models, Repository implementations
  - Presentation layer: Cubits, Screens, Widgets
- **NEVER** mix layers (e.g., don't import data models in domain layer)
- **ALWAYS** use dependency injection (GetIt) for all dependencies
- **ALWAYS** use Cubit for state management (NO setState in complex screens)

#### 3. Internationalization (i18n) - NO HARDCODED TEXT
- **NEVER** use hardcoded text strings in code
- **ALWAYS** add translations to `assets/translations/en.json` and `assets/translations/ar.json` FIRST
- **ALWAYS** use `.tr()` extension for all user-facing text
- **BEFORE** adding any text to UI:
  1. Add translation key to both `en.json` and `ar.json`
  2. Use the translation key with `.tr()` in code
- Example:
  ```dart
  // ❌ WRONG - Hardcoded text
  Text('Welcome to Dashboard')
  
  // ✅ CORRECT - Translated text
  // First add to en.json: "dashboard.welcome": "Welcome to Dashboard"
  // First add to ar.json: "dashboard.welcome": "مرحباً بك في لوحة التحكم"
  Text('dashboard.welcome'.tr())
  ```

#### 4. State Management
- **MUST** use Cubit (flutter_bloc) for state management
- **MUST** use StatelessWidget when possible (use Cubit for state)
- **MUST** register all Cubits in `injection_container.dart`
- **MUST** use BlocProvider, BlocListener, and BlocBuilder pattern

#### 5. Code Organization
- **MUST** keep each feature in its own folder under `features/`
- **MUST** separate concerns: screens, widgets, cubits in separate files
- **MUST** use meaningful file and class names
- **MUST** follow the existing folder structure

### Code Review Checklist

Before submitting any code, ensure:
- [ ] No screen file exceeds 150 lines
- [ ] All text is translated (no hardcoded strings)
- [ ] Clean Architecture structure is followed
- [ ] Cubit is used for state management
- [ ] Dependencies are registered in `injection_container.dart`
- [ ] Routes are added to `app_router.dart` if needed
- [ ] All translations are added to both `en.json` and `ar.json`
- [ ] RTL support is considered for Arabic locale