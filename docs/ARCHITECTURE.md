# Project Architecture

## Overview

Extro follows Clean Architecture principles, separating the application into three main layers:

### 1. Data Layer
Located in `lib/features/*/data/`

**Responsibilities:**
- API communication
- Data models (Request/Response)
- Repository implementations
- Data source management

**Key Components:**
- `models/`: Freezed models for API responses with `fromJson` and `toDomain()` methods
- `repositories/`: Implementation of repository interfaces from the domain layer
- `datasources/`: Remote and local data sources

### 2. Domain Layer
Located in `lib/features/*/domain/`

**Responsibilities:**
- Business logic
- Entity definitions
- Repository interfaces
- State management (Cubits)

**Key Components:**
- `entities/`: Domain models representing business objects
- `repositories/`: Repository interfaces (prefixed with 'I')
- `cubits/`: State management with flutter_bloc

### 3. Presentation Layer
Located in `lib/features/*/presentation/`

**Responsibilities:**
- UI components
- Screens
- Widgets
- User interaction handling

**Key Components:**
- `screens/`: Full screen widgets
- `widgets/`: Reusable UI components

## Core Directory

`lib/core/` contains application-wide utilities:

### Dependency Injection
- `di/injection.dart`: GetIt locator setup
- `di/register_module.dart`: Injectable module registration

### Network
- `network/i_network_client.dart`: Network client interface
- `network/network_client.dart`: Dio-based implementation
- `network/endpoints.dart`: API endpoint constants

### Error Handling
- `failures/failure.dart`: Freezed union for error types
- `failures/display_error.dart`: User-friendly error messages

### Extensions
- `extensions/context_extensions.dart`: BuildContext helpers

### Providers
- `providers/date_time_provider.dart`: Testable DateTime provider
- `providers/feature_flag_service.dart`: Feature flag control service
- `providers/i_feature_flag_service.dart`: Feature flag service interface

### Utils
- `utils/date_time_converter.dart`: DateTime parsing utilities

## Common Directory

`lib/common/` contains shared resources:

### Presentation
- `presentation/ui_utils/app_toast.dart`: Toast notifications
- `presentation/widgets/`: Shared widgets

### Data & Domain
- Shared entities and repositories used across features

## Localization

`lib/l10n/` contains ARB files for internationalization.

## Generated Files

`lib/gen/` contains auto-generated code (gitignored):
- Freezed models (*.freezed.dart)
- JSON serialization (*.g.dart)
- Dependency injection (*.config.dart)
- Localization files

## Assets

`assets/` contains static resources:
- `fonts/`: Custom font files
- `images/`: Image assets (PNG, JPG)
- `svgs/`: SVG vector graphics

## Best Practices

1. **Immutability**: Use Freezed for all models, entities, and states
2. **Dependency Injection**: Register dependencies with Injectable
3. **Error Handling**: Return Either<Failure, Success> from repositories
4. **State Management**: Use Cubits with well-defined states
5. **Localization**: Use context.localizer for all user-facing strings
6. **DateTime Handling**: String in response models, DateTime? in entities
7. **Clean Code**: Self-documenting code without unnecessary comments
