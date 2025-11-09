# Development Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (>= 3.0.0)
- **Dart SDK** (>= 3.0.0)
- **Git**
- **IDE**: VS Code or Android Studio

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/shihabkandil/extro.git
cd extro
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run Code Generation

Generate freezed models, JSON serialization, and dependency injection:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For development with auto-regeneration:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

### 4. Generate Localizations

```bash
flutter gen-l10n
```

## Running the Application

### Development Mode

```bash
flutter run
```

### Release Mode

```bash
flutter run --release
```

### Specific Platform

```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Desktop
flutter run -d macos
flutter run -d windows
flutter run -d linux
```

## Code Generation

This project uses several code generation tools:

### Freezed (Immutable Models)

When you create or modify:
- Entities
- States
- Request/Response models

Run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Injectable (Dependency Injection)

When you add new:
- Repositories
- Services
- Providers

Run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Localization

When you modify `lib/l10n/app_en.arb`:

```bash
flutter gen-l10n
```

## Common Commands

### Clean Build

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### Analyze Code

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Format Code

```bash
dart format .
```

## IDE Setup

### VS Code

Recommended extensions:
- Flutter
- Dart
- Dart Data Class Generator
- Error Lens

### Android Studio

Install:
- Flutter plugin
- Dart plugin

## Troubleshooting

### Build Runner Issues

If you encounter issues with code generation:

```bash
flutter clean
flutter pub get
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Localization Not Working

Ensure you've run:
```bash
flutter gen-l10n
```

And that your MaterialApp includes the localization delegates.

### Dependency Injection Errors

Make sure you've:
1. Added the `@injectable` or `@singleton` annotation
2. Run `build_runner`
3. Called `configureDependencies()` in `main()`

## Project Structure

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed project structure documentation.

## Contributing

1. Create a feature branch
2. Make your changes
3. Run code generation if needed
4. Test your changes
5. Submit a pull request

## Need Help?

- Check the [Flutter documentation](https://flutter.dev/docs)
- Review the [Clean Architecture guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- Read our [ARCHITECTURE.md](./ARCHITECTURE.md)
