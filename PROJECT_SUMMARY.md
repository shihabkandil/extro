# Extro - Expense Tracking Application

## Project Overview

Extro is a Flutter-based expense and income tracking application built following Clean Architecture principles. The project provides a solid foundation for building a scalable, maintainable mobile application with proper separation of concerns.

## Project Structure Summary

### 📁 Directory Structure

```
extro/
├── assets/                  # Static resources
│   ├── fonts/              # Custom font files
│   ├── images/             # Image assets (PNG, JPG)
│   └── svgs/               # SVG vector graphics
│
├── docs/                    # Comprehensive documentation
│   ├── ARCHITECTURE.md     # Architecture overview and patterns
│   ├── CODING_GUIDELINES.md # Coding standards and best practices
│   ├── FEATURE_GUIDE.md    # Step-by-step feature implementation guide
│   └── SETUP.md            # Development setup instructions
│
├── lib/                     # Application source code
│   ├── common/             # Shared utilities and components
│   │   ├── constants/      # App-wide constants
│   │   ├── data/           # Shared data models
│   │   ├── domain/         # Shared business logic
│   │   └── presentation/   # Shared UI components
│   │       ├── ui_utils/   # Toast notifications, dialogs
│   │       └── widgets/    # Reusable widgets
│   │
│   ├── core/               # Core functionality
│   │   ├── di/             # Dependency injection setup
│   │   ├── extensions/     # Dart extensions
│   │   ├── failures/       # Error handling
│   │   ├── network/        # HTTP client and API config
│   │   ├── providers/      # Service providers
│   │   └── utils/          # Utility functions
│   │
│   ├── features/           # Feature modules (Clean Architecture)
│   │   └── example/        # Example feature implementation
│   │       ├── data/       # Data layer
│   │       │   ├── models/ # Response models
│   │       │   ├── repositories/ # Repository implementations
│   │       │   └── datasources/ # Data sources
│   │       ├── domain/     # Domain layer
│   │       │   ├── entities/ # Business entities
│   │       │   ├── cubits/ # State management
│   │       │   └── repositories/ # Repository interfaces
│   │       └── presentation/ # Presentation layer
│   │           ├── screens/ # Full-page screens
│   │           └── widgets/ # Feature-specific widgets
│   │
│   ├── gen/                # Generated files (gitignored)
│   ├── l10n/               # Localization
│   │   └── app_en.arb     # English translations
│   └── main.dart           # Application entry point
│
├── .gitignore              # Git ignore rules
├── analysis_options.yaml   # Dart analyzer configuration
├── build.yaml             # Code generation configuration
├── l10n.yaml              # Localization configuration
├── pubspec.yaml           # Dependencies and assets
└── README.md              # Project README
```

## Key Features

### ✅ Clean Architecture
- **Three-layer architecture**: Data, Domain, and Presentation
- **Dependency Rule**: Dependencies point inward
- **Separation of Concerns**: Each layer has distinct responsibilities

### ✅ State Management
- **flutter_bloc**: Cubit pattern for state management
- **Freezed unions**: Type-safe state representation
- **Error handling**: Built-in failure handling

### ✅ Dependency Injection
- **get_it + injectable**: Constructor-based dependency injection
- **Singleton pattern**: For repositories and services
- **Testability**: Easy to mock dependencies

### ✅ Immutability
- **Freezed**: All models, entities, and states are immutable
- **Type safety**: Compile-time safety with sealed classes
- **Code generation**: Automatic boilerplate code

### ✅ Network Layer
- **Dio**: HTTP client with interceptors
- **Error handling**: Either<Failure, Success> pattern
- **Logging**: Pretty logging for debugging

### ✅ Localization
- **flutter_gen**: Type-safe localization
- **ARB files**: Standard localization format
- **Context extension**: Easy access to translations

### ✅ Code Quality
- **flutter_lints**: Official Flutter linting rules
- **analysis_options.yaml**: Custom lint rules
- **Consistent patterns**: Documented coding standards

## Technology Stack

### Core Dependencies
- **Flutter SDK**: >=3.0.0
- **Dart SDK**: >=3.0.0

### State Management
- **flutter_bloc**: ^8.1.3
- **equatable**: ^2.0.5

### Dependency Injection
- **get_it**: ^7.6.4
- **injectable**: ^2.3.2

### Immutable Models
- **freezed**: ^2.4.5
- **freezed_annotation**: ^2.4.1
- **json_annotation**: ^4.8.1

### Network
- **dio**: ^5.3.3
- **pretty_dio_logger**: ^1.3.1

### Functional Programming
- **dartz**: ^0.10.1

### Code Generation
- **build_runner**: ^2.4.6
- **json_serializable**: ^6.7.1
- **injectable_generator**: ^2.4.1

## Implemented Components

### Core Components (19 Dart files)
1. **Dependency Injection**
   - `injection.dart`: GetIt configuration
   - `register_module.dart`: Dio module registration

2. **Network Layer**
   - `i_network_client.dart`: Network client interface
   - `network_client.dart`: Dio-based implementation
   - `endpoints.dart`: API endpoint constants

3. **Error Handling**
   - `failure.dart`: Freezed failure types
   - `display_error.dart`: User-friendly error messages

4. **Utilities**
   - `context_extensions.dart`: BuildContext helpers
   - `date_time_converter.dart`: DateTime parsing
   - `app_toast.dart`: Toast notifications
   - `date_time_provider.dart`: Testable DateTime provider

5. **Example Feature**
   - Complete implementation following Clean Architecture
   - Entity, repository interface, repository implementation
   - Cubit with state management
   - Response model with domain mapping
   - Example screen with BlocConsumer

## Documentation

### 📖 Available Guides

1. **ARCHITECTURE.md**
   - Clean Architecture overview
   - Layer responsibilities
   - Directory structure explained
   - Best practices

2. **CODING_GUIDELINES.md**
   - Naming conventions
   - Freezed usage patterns
   - State management guidelines
   - Error handling patterns
   - DateTime handling
   - Localization usage
   - Commit message format

3. **FEATURE_GUIDE.md**
   - Step-by-step feature implementation
   - Complete expense tracking example
   - Request/Response model patterns
   - Cubit implementation
   - Screen creation with BlocConsumer
   - Common patterns and practices

4. **SETUP.md**
   - Development environment setup
   - Code generation commands
   - Running the application
   - Troubleshooting guide

## Next Steps

### To Start Developing:

1. **Run code generation**:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   flutter gen-l10n
   ```

2. **Create your first feature**:
   - Follow the FEATURE_GUIDE.md
   - Use expense/income tracking examples
   - Implement transactions, categories, reports

3. **Add business logic**:
   - Create expense tracking features
   - Implement income management
   - Add category management
   - Build reporting and analytics

4. **Enhance UI**:
   - Design transaction screens
   - Create dashboard with charts
   - Add filtering and search
   - Implement budget tracking

## Architectural Patterns

### Request Flow
```
UI (Presentation)
  ↓
Cubit (Domain)
  ↓
Repository Interface (Domain)
  ↓
Repository Implementation (Data)
  ↓
Network Client (Core)
  ↓
API
```

### Data Flow
```
API Response (JSON)
  ↓
Response Model (Data)
  ↓
toDomain() extension
  ↓
Entity (Domain)
  ↓
Cubit State (Domain)
  ↓
UI (Presentation)
```

### Error Handling Flow
```
API Error
  ↓
Network Client → Failure
  ↓
Repository → Either<Failure, Success>
  ↓
Cubit → State.failure(failure)
  ↓
BlocListener → AppToast.showError()
  ↓
User sees localized error message
```

## Code Generation

The project uses several code generators:

1. **Freezed**: Immutable models and unions
2. **JSON Serializable**: JSON parsing
3. **Injectable**: Dependency injection
4. **Flutter Gen**: Localization

Run after changes:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Testing Strategy

### Unit Tests
- Repository tests with mocked network client
- Cubit tests with mocked repository
- Utility function tests

### Widget Tests
- Screen widget tests
- Reusable widget tests

### Integration Tests
- End-to-end feature tests
- Navigation flow tests

## Git Workflow

### Semantic Commits
All commits follow the format:
```
type: Description starting with capital letter
```

Types: feat, fix, docs, style, refactor, test, chore

### Example Commits
- `feat: Add expense tracking screen`
- `fix: Resolve null pointer in transaction cubit`
- `docs: Update API integration guide`
- `refactor: Extract budget calculation logic`

## Summary

The Extro project is now fully structured and ready for expense tracking feature development. All architectural patterns, coding conventions, and best practices are documented and exemplified. The project follows industry-standard practices and provides a solid foundation for building a production-ready expense tracking application.

### What's Included:
✅ Complete directory structure
✅ Clean Architecture implementation
✅ Core utilities and error handling
✅ Dependency injection setup
✅ Network client configuration
✅ Localization setup
✅ Example feature module
✅ Comprehensive documentation
✅ Code generation configuration
✅ Git ignore rules
✅ Linting configuration

### Ready for:
🚀 Feature development
🚀 UI implementation
🚀 Business logic
🚀 Testing
🚀 Production deployment
