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
