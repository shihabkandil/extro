# Coding Guidelines for AI Agents

## Project Overview

Extro is a Flutter-based expense and income tracking application built following Clean Architecture principles. The project provides a solid foundation for building a scalable, maintainable mobile application with proper separation of concerns.

## Clean Architecture

### Three-Layer Architecture

#### 1. Data Layer (`lib/features/*/data/`)
**Responsibilities:**
- API communication
- Data models (Request/Response)
- Repository implementations
- Data source management

**Key Components:**
- `models/`: Freezed models for API responses with `fromJson` and `toDomain()` methods
- `repositories/`: Implementation of repository interfaces from the domain layer
- `datasources/`: Remote and local data sources

#### 2. Domain Layer (`lib/features/*/domain/`)
**Responsibilities:**
- Business logic
- Entity definitions
- Repository interfaces
- State management (Cubits)

**Key Components:**
- `entities/`: Domain models representing business objects
- `repositories/`: Repository interfaces (prefixed with 'I')
- `cubits/`: State management with flutter_bloc

#### 3. Presentation Layer (`lib/features/*/presentation/`)
**Responsibilities:**
- UI components
- Screens
- Widgets
- User interaction handling

**Key Components:**
- `screens/`: Full screen widgets
- `widgets/`: Reusable UI components

### Dependency Rule
Dependencies always point inward. The domain layer should never depend on the data or presentation layers.

### Data Flow
```
API Response (JSON)
  ↓
Response Model (Data Layer)
  ↓
toDomain() extension
  ↓
Entity (Domain Layer)
  ↓
Cubit State (Domain Layer)
  ↓
UI (Presentation Layer)
```

## General Principles

### 1. Code Consistency
Always maintain consistency with existing patterns. When implementing new features, reference existing implementations in similar features.

### 2. Self-Documenting Code
Write code that is self-explanatory through:
- Clear, descriptive naming
- Proper structure and organization
- Minimal use of comments (only for complex logic)

### 3. Comments
- **Avoid writing comments** unless it's a complex logic or something that truly needs clarification
- Code should be self-documenting with clear variable and function names
- Only add comments for:
  - Complex algorithms or business logic
  - Non-obvious workarounds
  - Important architectural decisions
  - Public API documentation

## Naming Conventions

### Files and Directories
- Use `snake_case` for all files and directories
- Examples: `expense_repository.dart`, `transaction_tile.dart`, `monthly_report_cubit.dart`

### Classes
- Use `UpperCamelCase`
- Examples: `ExpenseRepository`, `MonthlyReportCubit`, `TransactionTile`

### Variables and Methods
- Use `lowerCamelCase`
- Examples: `transactionList`, `calculateTotal()`, `isLoading`

### Constants
- Use `lowerCamelCase`
- Example: `const maxRetries = 3;`

### Model Suffixes
- Response models: End with `Response` (e.g., `ExpenseResponse`, `IncomeResponse`)
- Domain entities: Use natural names (e.g., `Expense`, `Income`, `Transaction`, `Category`)
- Params classes: End with `Params` (e.g., `FilterTransactionsParams`)

## Code Organization

### Widget Structure
- Extract stateless widgets into separate files in a `widgets` directory within the feature
- Follow the project's feature-based structure: `lib/features/{feature}/presentation/widgets/`
- Each widget should be in its own file with a descriptive name
- Private widgets (prefixed with `_`) used only within a single file should remain in that file

### File Naming
- Use snake_case for file names (e.g., `metric_card.dart`, `transaction_tile.dart`)
- Widget file names should match the widget class name in snake_case

### Imports
- Group imports: Flutter SDK, packages, local files
- Use relative imports for files within the same feature
- Use absolute imports for cross-feature references

Example:
```dart
// Flutter SDK
import 'package:flutter/material.dart';

// Packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Local files
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
```

## Freezed Usage

### Always Use Freezed For:
1. Entities
2. States
3. Request/Response models
4. Params classes

### Entity Example
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';

@freezed
sealed class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required String description,
    required double amount,
    required TransactionType type,
    DateTime? date,
  }) = _Transaction;
}
```

### State Example
```dart
@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.success(List<Transaction> transactions) = _Success;
  const factory TransactionState.failure(Failure failure) = _Failure;
}
```

### Response Model Example
```dart
@freezed
sealed class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int id,
    required String description,
    required double amount,
    @Default('') String createdAt,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
}

extension TransactionResponseMapper on TransactionResponse {
  Transaction toDomain() {
    return Transaction(
      id: id,
      description: description,
      amount: amount,
      createdAt: DateTimeConverter.fromJson(createdAt),
    );
  }
}
```

## State Management

### Cubit Implementation
1. Check `isClosed` before emitting
2. Use constructor injection with locator fallback
3. Handle errors with Either pattern

```dart
class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit({
    ITransactionRepository? repository,
  })  : _repository = repository ?? locator<ITransactionRepository>(),
        super(const TransactionState.initial());

  final ITransactionRepository _repository;

  Future<void> loadTransactions() async {
    emit(const TransactionState.loading());

    final result = await _repository.getAll();

    if (isClosed) return;

    result.fold(
      (failure) => emit(TransactionState.failure(failure)),
      (transactions) => emit(TransactionState.success(transactions)),
    );
  }
}
```

### BlocConsumer Pattern
```dart
BlocConsumer<TransactionCubit, TransactionState>(
  listener: (context, state) {
    state.whenOrNull(
      failure: (failure) => AppToast.showError(
        DisplayError.fromFailure(context.localizer, failure),
      ),
    );
  },
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      success: (transactions) => TransactionList(transactions: transactions),
      failure: (_) => const ErrorWidget(),
    );
  },
)
```

## Dependency Injection

### Repository Registration
```dart
@Singleton(as: ITransactionRepository)
class TransactionRepository implements ITransactionRepository {
  TransactionRepository({required INetworkClient client}) : _client = client;
  
  final INetworkClient _client;
  // Implementation...
}
```

### Module Registration
```dart
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio();
}
```

## Error Handling

### Repository Pattern
Return `Either<Failure, Success>`:

```dart
@override
Future<Either<Failure, List<Transaction>>> getAll() async {
  final response = await _client.get(Endpoints.transactions);

  return response.fold(
    (failure) => Left(failure),
    (res) {
      try {
        final data = TransactionListResponse.fromJson(res.data);
        return Right(data.toDomain());
      } catch (e, stackTrace) {
        log('Parse error: $e', error: e, stackTrace: stackTrace);
        return Left(Failure.dataProcessing());
      }
    },
  );
}
```

### UI Error Display
Use AppToast with DisplayError:

```dart
BlocListener<TransactionCubit, TransactionState>(
  listener: (context, state) {
    state.whenOrNull(
      failure: (failure) => AppToast.showError(
        DisplayError.fromFailure(context.localizer, failure),
      ),
    );
  },
)
```

## DateTime Handling

### Response Models
Store as String with default empty value:

```dart
@freezed
sealed class OrderResponse with _$OrderResponse {
  const factory OrderResponse({
    required int id,
    @Default('') String createdAt,
  }) = _OrderResponse;
}
```

### Domain Entities
Convert to nullable DateTime:

```dart
extension OrderResponseMapper on OrderResponse {
  Order toDomain() {
    return Order(
      id: id,
      createdAt: DateTimeConverter.fromJson(createdAt),
    );
  }
}

@freezed
sealed class Order with _$Order {
  const factory Order({
    required int id,
    DateTime? createdAt,
  }) = _Order;
}
```

## Theme and Styling

### Use Context Extensions
- **Always use theme and textTheme extensions** from `context_extensions.dart`
- Instead of `Theme.of(context)`, use `context.theme`
- Instead of `Theme.of(context).textTheme`, use `context.textTheme`
- Instead of hardcoded TextStyles, prefer using theme text styles:
  ```dart
  // Bad
  Text('Title', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
  
  // Good
  Text('Title', style: context.textTheme.headlineLarge)
  ```

### Available Context Extensions
- `context.localizer` - for localization
- `context.theme` - for theme data
- `context.textTheme` - for text theme
- `context.colorScheme` - for color scheme
- `context.mediaQuery` - for media query
- `context.screenSize` - for screen size
- `context.screenWidth` - for screen width
- `context.screenHeight` - for screen height

### Constants
- Define all colors in `AppColors` class
- Define all dimensions/spacing as constants when reused
- Use const constructors wherever possible

## Localization

### Using Translations
Always use `context.localizer`:

```dart
// ✅ Correct
Text(context.localizer.welcome)

// ❌ Incorrect
Text(AppLocalizations.of(context).welcome)
```

### Adding Translations
Add to `lib/l10n/app_en.arb`:

```json
{
  "welcome": "Welcome to Extro",
  "@welcome": {
    "description": "Welcome message shown to users"
  }
}
```

### Generated Files
- Localization Dart files (`app_localizations.dart`, `app_localizations_*.dart`) are **generated files**
- They should be listed in `.gitignore`
- Only the ARB files (`app_en.arb`, etc.) should be committed
- Generated files are created by running `flutter gen-l10n`

## Best Practices

### Performance
- Use `const` constructors whenever possible
- Avoid rebuilding widgets unnecessarily
- Use `ListView.builder` for long lists instead of `ListView`

### Accessibility
- Provide semantic labels for interactive elements
- Ensure proper contrast ratios for text
- Use SafeArea for proper layout on all devices

### Testing
- Write unit tests for business logic
- Write widget tests for UI components
- Follow existing test patterns in the project

## Code Generation

Run after creating or modifying:
- Entities
- States
- Request/Response models
- Repository registrations

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

For development with auto-regeneration:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Commit Messages

Use semantic commit format:

```
type: Description starting with capital letter

Types: feat, fix, docs, style, refactor, test, chore

Examples:
feat: Add expense tracking screen
fix: Resolve null pointer in transaction cubit
docs: Update API integration guide
refactor: Extract budget calculation logic
test: Add unit tests for income repository
chore: Update dependencies
```

## Examples

### Complete Feature Structure

```
lib/features/transactions/
├── data/
│   ├── models/
│   │   └── transaction_response.dart
│   └── repositories/
│       └── transaction_repository.dart
├── domain/
│   ├── entities/
│   │   └── transaction.dart
│   ├── cubits/
│   │   └── transaction_cubit/
│   │       ├── transaction_cubit.dart
│   │       └── transaction_state.dart
│   └── repositories/
│       └── i_transaction_repository.dart
└── presentation/
    ├── screens/
    │   └── transaction_list_screen.dart
    └── widgets/
        ├── transaction_tile.dart
        └── transaction_header.dart
```

### Good Widget Structure
```dart
// lib/features/dashboard/presentation/widgets/metric_card.dart
import 'package:flutter/material.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';

class MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final List<Color> gradientColors;

  const MetricCard({
    super.key,
    required this.value,
    required this.label,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(label, style: context.textTheme.labelMedium),
          Text(value, style: context.textTheme.headlineLarge),
        ],
      ),
    );
  }
}
```

### Using Theme Extensions
```dart
// Good
Text(
  'Welcome',
  style: context.textTheme.headlineMedium?.copyWith(
    color: AppColors.primary,
  ),
)

// Bad
Text(
  'Welcome',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
)
```

## Code Review Checklist

Before submitting:
- [ ] Follows existing code patterns
- [ ] Uses Freezed for models/states
- [ ] Implements proper error handling
- [ ] Uses context.localizer for strings
- [ ] Uses context.textTheme for text styles
- [ ] Includes appropriate logging
- [ ] Checks isClosed in cubits
- [ ] Follows naming conventions
- [ ] No unnecessary comments
- [ ] Semantic commit messages
- [ ] Code generation run successfully
- [ ] Uses const constructors where possible
- [ ] Proper widget organization (separate files in widgets directory)

## Common Patterns

### Repository Implementation
```dart
@Singleton(as: ITransactionRepository)
class TransactionRepository implements ITransactionRepository {
  TransactionRepository({required INetworkClient client}) : _client = client;

  final INetworkClient _client;

  @override
  Future<Either<Failure, List<Transaction>>> getAll() async {
    final response = await _client.get(Endpoints.transactions);

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = (res.data as List)
              .map((json) => TransactionResponse.fromJson(json))
              .map((response) => response.toDomain())
              .toList();
          return Right(data);
        } catch (e, stackTrace) {
          log('Parse error: $e', error: e, stackTrace: stackTrace);
          return Left(Failure.dataProcessing());
        }
      },
    );
  }
}
```

### Screen with BlocProvider
```dart
class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit()..loadTransactions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.localizer.transactions),
        ),
        body: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (failure) => AppToast.showError(
                DisplayError.fromFailure(context.localizer, failure),
              ),
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (transactions) => ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionTile(transaction: transactions[index]);
                },
              ),
              failure: (_) => Center(
                child: Text(context.localizer.unknownError),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

## Technology Stack Reference

### Core Dependencies
- **Flutter SDK**: >=3.0.0
- **Dart SDK**: >=3.0.0

### State Management
- **flutter_bloc**: Cubit pattern for state management
- **equatable**: Value equality for objects

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation for DI

### Immutability
- **freezed**: Immutable models and unions
- **freezed_annotation**: Annotations for freezed

### Network
- **dio**: HTTP client
- **pretty_dio_logger**: Logging for debugging

### Functional Programming
- **dartz**: Either, Option, and other functional types

### Code Generation
- **build_runner**: Code generation runner
- **json_serializable**: JSON serialization
- **injectable_generator**: DI code generation
