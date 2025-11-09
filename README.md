# Extro

A Flutter customer application built with Clean Architecture principles.

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
```

4. Run the app:
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

See the developer agent guidelines in `.github/agents/` for detailed coding conventions and best practices.

## 📄 License

This project is licensed under the MIT License.