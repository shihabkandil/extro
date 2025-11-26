[![iOS CI Build](https://github.com/shihabkandil/extro/actions/workflows/ios_ci.yaml/badge.svg)](https://github.com/shihabkandil/extro/actions/workflows/ios_ci.yaml)
[![Android CI Build](https://github.com/shihabkandil/extro/actions/workflows/android_ci.yaml/badge.svg)](https://github.com/shihabkandil/extro/actions/workflows/android_ci.yaml)
[![PR Analyze & Format Checks](https://github.com/shihabkandil/extro/actions/workflows/pr_analyze_checks.yaml/badge.svg)](https://github.com/shihabkandil/extro/actions/workflows/pr_analyze_checks.yaml)
# Extro

A Flutter expense and income tracking application built with Clean Architecture principles.

## 🏗️ Architecture

This project follows **Clean Architecture** with three main layers:

- **Data Layer**: API clients, repositories, request/response models
- **Domain Layer**: Business logic, entities, cubits, repository interfaces
- **Presentation Layer**: UI components, screens, widgets

## 📁 Project Structure

```
lib/
├── common/          # Shared utilities and components
│   ├── constants/
│   ├── data/
│   ├── domain/
│   └── presentation/
│       ├── ui_utils/
│       └── widgets/
├── core/           # Core functionality
│   ├── di/         # Dependency injection
│   ├── network/    # Network client and API setup
│   ├── failures/   # Error handling
│   ├── extensions/ # Dart extensions
│   ├── providers/  # Service providers
│   └── utils/      # Utility functions
├── features/       # Feature modules
│   └── example/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── datasources/
│       ├── domain/
│       │   ├── entities/
│       │   ├── cubits/
│       │   └── repositories/
│       └── presentation/
│           ├── screens/
│           └── widgets/
├── gen/           # Generated files (localization, code generation)
└── l10n/          # Localization files

assets/
├── fonts/         # Font files
├── images/        # Image assets
└── svgs/          # SVG files
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/shihabkandil/extro.git
cd extro
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

4. Configure OAuth providers (optional for development):
   - See [docs/OAUTH_SETUP.md](lib/features/auth/OAUTH_SETUP.md) for Google and Apple Sign-In setup
   - Configure OAuth credentials in Google Cloud Console and Apple Developer Portal

5. Run the app:
```bash
flutter run
```

## 🔧 Key Technologies

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it + injectable
- **Immutable Models**: freezed
- **Network**: dio
- **Functional Programming**: dartz
- **Localization**: flutter_localizations
- **Authentication**: google_sign_in + sign_in_with_apple

## ✨ Features

- **OAuth Authentication**: Sign in with Google and Apple (no Firebase required)
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **Type-safe Models**: Immutable data structures using Freezed
- **Error Handling**: Comprehensive error handling with Either pattern
- **Internationalization**: Multi-language support ready

## 📝 Code Generation

This project uses code generation for:
- Freezed models
- JSON serialization
- Dependency injection
- Localization

Run the following command after making changes:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Or use watch mode for development:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## 🌍 Localization

Add translations to `lib/l10n/app_en.arb` and run:

```bash
flutter gen-l10n
```

## 📖 Developer Guidelines

See the comprehensive documentation in the `docs/` directory:

- **[ARCHITECTURE.md](docs/ARCHITECTURE.md)** - Architecture overview and patterns
- **[CODING_GUIDELINES.md](docs/CODING_GUIDELINES.md)** - Coding conventions and best practices
- **[FEATURE_GUIDE.md](docs/FEATURE_GUIDE.md)** - Step-by-step feature implementation guide
- **[SETUP.md](docs/SETUP.md)** - Development environment setup

## 📄 License

This project is licensed under the MIT License.