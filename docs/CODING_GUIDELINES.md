# Coding Guidelines

## General Principles

### 1. Code Consistency
Always maintain consistency with existing patterns. When implementing new features, reference existing implementations in similar features.

### 2. Self-Documenting Code
Write code that is self-explanatory through:
- Clear, descriptive naming
- Proper structure and organization
- Minimal use of comments (only for complex logic)

### 3. Clean Architecture
Follow the three-layer architecture:
- **Data Layer**: Models, repositories, data sources
- **Domain Layer**: Entities, cubits, repository interfaces
- **Presentation Layer**: Screens, widgets

## Naming Conventions

### Files and Directories
- Use `snake_case` for all files and directories
- Example: `expense_repository.dart`, `monthly_report_cubit.dart`

### Classes
- Use `UpperCamelCase`
- Example: `ExpenseRepository`, `MonthlyReportCubit`

### Variables and Methods
- Use `lowerCamelCase`
- Example: `transactionList`, `calculateTotal()`

### Constants
- Use `lowerCamelCase`
- Example: `const maxRetries = 3;`

### Model Suffixes
- Response models: End with `Response` (e.g., `ExpenseResponse`, `IncomeResponse`)
- Domain entities: Use natural names (e.g., `Expense`, `Income`, `Transaction`, `Category`)
- Params classes: End with `Params` (e.g., `FilterTransactionsParams`)

## Freezed Usage

### Always Use Freezed For:
1. Entities
2. States
3. Request/Response models
4. Params classes

### Example

```dart
@freezed
sealed class Transaction with _$Transaction {
  const factory Transaction({
    required int id,
    required String description,
    required double amount,
    required TransactionType type,
  }) = _Transaction;
}
```

## State Management

### Cubit States
Use union types with standard states:

```dart
@freezed
sealed class ExampleState with _$ExampleState {
  const factory ExampleState.initial() = _Initial;
  const factory ExampleState.loading() = _Loading;
  const factory ExampleState.success(Data data) = _Success;
  const factory ExampleState.failure(Failure failure) = _Failure;
}
```

### Cubit Implementation
1. Check `isClosed` before emitting
2. Use constructor injection with locator fallback
3. Handle errors with Either pattern

```dart
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit({
    IExampleRepository? repository,
  })  : _repository = repository ?? locator<IExampleRepository>(),
        super(const ExampleState.initial());

  final IExampleRepository _repository;

  Future<void> load() async {
    emit(const ExampleState.loading());

    final result = await _repository.getData();

    if (isClosed) return;

    result.fold(
      (failure) => emit(ExampleState.failure(failure)),
      (data) => emit(ExampleState.success(data)),
    );
  }
}
```

## Dependency Injection

### Repository Registration

```dart
@Singleton(as: IExpenseRepository)
class ExpenseRepository implements IExpenseRepository {
  ExpenseRepository({required INetworkClient client}) : _client = client;
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
Future<Either<Failure, List<Expense>>> getAll() async {
  final response = await _client.get(Endpoints.expenses);

  return response.fold(
    (failure) => Left(failure),
    (res) {
      try {
        final data = ExpenseListResponse.fromJson(res.data);
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
BlocListener<ExpenseCubit, ExpenseState>(
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
Store as String:

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
Convert to DateTime?:

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
    "description": "Welcome message"
  }
}
```

## Request/Response Models

### Structure

```dart
// Response model
@freezed
sealed class IncomeResponse with _$IncomeResponse {
  const factory IncomeResponse({
    required int id,
    required String source,
    required double amount,
  }) = _IncomeResponse;

  factory IncomeResponse.fromJson(Map<String, dynamic> json) =>
      _$IncomeResponseFromJson(json);
}

// Mapper extension in same file
extension IncomeResponseMapper on IncomeResponse {
  Income toDomain() {
    return Income(
      id: id,
      source: source,
      amount: amount,
    );
  }
}
```

## Commit Messages

Use semantic commit format:

```
type: Description starting with capital letter

Examples:
feat: Add expense tracking screen
fix: Resolve null pointer in transaction cubit
docs: Update API integration guide
refactor: Extract budget calculation logic
test: Add unit tests for income repository
chore: Update dependencies
```

## Code Review Checklist

Before submitting:
- [ ] Follows existing code patterns
- [ ] Uses Freezed for models/states
- [ ] Implements proper error handling
- [ ] Uses context.localizer for strings
- [ ] Includes appropriate logging
- [ ] Checks isClosed in cubits
- [ ] Follows naming conventions
- [ ] No unnecessary comments
- [ ] Semantic commit messages
