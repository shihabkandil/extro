# Feature Implementation Guide

This guide walks you through creating a new feature following the clean architecture pattern for the Extro expense tracking application.

## Overview

Every feature should have:
1. **Data Layer**: Models and repository implementation
2. **Domain Layer**: Entities, repository interface, and cubit
3. **Presentation Layer**: Screens and widgets

## Step-by-Step Guide

### 1. Create Feature Directory Structure

```bash
mkdir -p lib/features/transactions/{data,domain,presentation}
mkdir -p lib/features/transactions/data/{models,repositories,datasources}
mkdir -p lib/features/transactions/domain/{entities,cubits,repositories}
mkdir -p lib/features/transactions/presentation/{screens,widgets}
```

### 2. Create Domain Entity

**File**: `lib/features/transactions/domain/entities/transaction.dart`

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
    required int categoryId,
    DateTime? date,
  }) = _Transaction;
}

enum TransactionType {
  expense,
  income,
}
```

### 3. Create Repository Interface

**File**: `lib/features/transactions/domain/repositories/i_transaction_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/transactions/domain/entities/transaction.dart';

abstract interface class ITransactionRepository {
  Future<Either<Failure, List<Transaction>>> getAll();
  Future<Either<Failure, Transaction>> getById(int id);
  Future<Either<Failure, Transaction>> create(Transaction transaction);
  Future<Either<Failure, void>> delete(int id);
}
```

### 4. Create Response Model

**File**: `lib/features/transactions/data/models/transaction_response.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extro/core/utils/date_time_converter.dart';
import 'package:extro/features/transactions/domain/entities/transaction.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

@freezed
sealed class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int id,
    required String description,
    required double amount,
    required String type,
    required int categoryId,
    @Default('') String date,
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
      type: type == 'expense' ? TransactionType.expense : TransactionType.income,
      categoryId: categoryId,
      date: DateTimeConverter.fromJson(date),
    );
  }
}
```

### 5. Create Repository Implementation

**File**: `lib/features/transactions/data/repositories/transaction_repository.dart`

```dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/core/network/endpoints.dart';
import 'package:extro/core/network/i_network_client.dart';
import 'package:extro/features/transactions/data/models/transaction_response.dart';
import 'package:extro/features/transactions/domain/entities/transaction.dart';
import 'package:extro/features/transactions/domain/repositories/i_transaction_repository.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: ITransactionRepository)
class TransactionRepository implements ITransactionRepository {
  final INetworkClient _client;

  TransactionRepository({required INetworkClient client}) : _client = client;

  @override
  Future<Either<Failure, List<Transaction>>> getAll() async {
    final response = await _client.get(
      Endpoints.transactions,
      requiresAuth: true,
    );

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = (res.data as List)
              .map((e) => TransactionResponse.fromJson(e as Map<String, dynamic>))
              .toList();
          return Right(data.map((e) => e.toDomain()).toList());
        } catch (e, stackTrace) {
          log(
            'Failed to parse TransactionResponse list: $e',
            error: e,
            stackTrace: stackTrace,
          );
          return Left(Failure.dataProcessing());
        }
      },
    );
  }

  @override
  Future<Either<Failure, Transaction>> getById(int id) async {
    final response = await _client.get(
      '${Endpoints.transactions}/$id',
      requiresAuth: true,
    );

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = TransactionResponse.fromJson(
            res.data as Map<String, dynamic>,
          );
          return Right(data.toDomain());
        } catch (e, stackTrace) {
          log(
            'Failed to parse TransactionResponse: $e',
            error: e,
            stackTrace: stackTrace,
          );
          return Left(Failure.dataProcessing());
        }
      },
    );
  }

  @override
  Future<Either<Failure, Transaction>> create(Transaction transaction) async {
    final response = await _client.post(
      Endpoints.transactions,
      data: {
        'description': transaction.description,
        'amount': transaction.amount,
        'type': transaction.type.name,
        'categoryId': transaction.categoryId,
        'date': transaction.date?.toIso8601String(),
      },
      requiresAuth: true,
    );

    return response.fold(
      (failure) => Left(failure),
      (res) {
        try {
          final data = TransactionResponse.fromJson(
            res.data as Map<String, dynamic>,
          );
          return Right(data.toDomain());
        } catch (e, stackTrace) {
          log(
            'Failed to parse TransactionResponse: $e',
            error: e,
            stackTrace: stackTrace,
          );
          return Left(Failure.dataProcessing());
        }
      },
    );
  }

  @override
  Future<Either<Failure, void>> delete(int id) async {
    final response = await _client.delete(
      '${Endpoints.transactions}/$id',
      requiresAuth: true,
    );

    return response.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }
}
```

### 6. Add Endpoint

**File**: `lib/core/network/endpoints.dart`

```dart
class Endpoints {
  // ... existing endpoints
  static String get transactions => '$apiVersion/transactions';
  static String get expenses => '$apiVersion/expenses';
  static String get incomes => '$apiVersion/incomes';
  static String get categories => '$apiVersion/categories';
}
```

### 7. Create Cubit State

**File**: `lib/features/transactions/domain/cubits/transaction_cubit/transaction_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:extro/core/failures/failure.dart';
import 'package:extro/features/transactions/domain/entities/transaction.dart';

part 'transaction_state.freezed.dart';

@freezed
sealed class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = _Initial;
  const factory TransactionState.loading() = _Loading;
  const factory TransactionState.success(List<Transaction> transactions) = _Success;
  const factory TransactionState.failure(Failure failure) = _Failure;
}
```

### 8. Create Cubit

**File**: `lib/features/transactions/domain/cubits/transaction_cubit/transaction_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extro/core/di/injection.dart';
import 'package:extro/features/transactions/domain/cubits/transaction_cubit/transaction_state.dart';
import 'package:extro/features/transactions/domain/repositories/i_transaction_repository.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit({
    ITransactionRepository? repository,
  })  : _repository = repository ?? locator<ITransactionRepository>(),
        super(const TransactionState.initial());

  final ITransactionRepository _repository;

  Future<void> loadAll() async {
    emit(const TransactionState.loading());

    final failureOrSuccess = await _repository.getAll();

    if (isClosed) return;

    failureOrSuccess.fold(
      (failure) => emit(TransactionState.failure(failure)),
      (transactions) => emit(TransactionState.success(transactions)),
    );
  }

  Future<void> loadById(int id) async {
    emit(const TransactionState.loading());

    final failureOrSuccess = await _repository.getById(id);

    if (isClosed) return;

    failureOrSuccess.fold(
      (failure) => emit(TransactionState.failure(failure)),
      (transaction) => emit(TransactionState.success([transaction])),
    );
  }

  Future<void> delete(int id) async {
    final failureOrSuccess = await _repository.delete(id);

    if (isClosed) return;

    failureOrSuccess.fold(
      (failure) => emit(TransactionState.failure(failure)),
      (_) => loadAll(),
    );
  }
}
```

### 9. Create Screen

**File**: `lib/features/transactions/presentation/screens/transaction_list_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extro/common/presentation/ui_utils/app_toast.dart';
import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/failures/display_error.dart';
import 'package:extro/features/transactions/domain/cubits/transaction_cubit/transaction_cubit.dart';
import 'package:extro/features/transactions/domain/cubits/transaction_cubit/transaction_state.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionCubit()..loadAll(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.localizer.transactions),
        ),
        body: BlocConsumer<TransactionCubit, TransactionState>(
          listener: (context, state) {
            state.whenOrNull(
              failure: (failure) {
                AppToast.showError(
                  DisplayError.fromFailure(context.localizer, failure),
                );
              },
            );
          },
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: Text('No transactions yet'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              success: (transactions) {
                if (transactions.isEmpty) {
                  return const Center(
                    child: Text('No transactions found'),
                  );
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    final isExpense = transaction.type == TransactionType.expense;
                    return ListTile(
                      leading: Icon(
                        isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isExpense ? Colors.red : Colors.green,
                      ),
                      title: Text(transaction.description),
                      subtitle: Text(
                        transaction.date?.toString() ?? 'No date',
                      ),
                      trailing: Text(
                        '\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isExpense ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
              failure: (_) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 16),
                    Text(context.localizer.unknownError),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to add transaction screen
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

### 10. Add Localization

**File**: `lib/l10n/app_en.arb`

```json
{
  "transactions": "Transactions",
  "@transactions": {
    "description": "Transactions screen title"
  },
  "expenses": "Expenses",
  "@expenses": {
    "description": "Expenses label"
  },
  "income": "Income",
  "@income": {
    "description": "Income label"
  },
  "addTransaction": "Add Transaction",
  "@addTransaction": {
    "description": "Add transaction button label"
  }
}
```

### 11. Run Code Generation

```bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

## Testing the Feature

Create test files in the `test/` directory mirroring the structure:

```
test/
└── features/
    └── transactions/
        ├── data/
        │   └── repositories/
        │       └── transaction_repository_test.dart
        └── domain/
            └── cubits/
                └── transaction_cubit_test.dart
```

## Checklist

Before considering the feature complete:

- [ ] Entity created with Freezed
- [ ] Repository interface defined
- [ ] Response model with fromJson and toDomain()
- [ ] Repository implementation with @Singleton
- [ ] Cubit state with freezed unions
- [ ] Cubit with constructor injection
- [ ] Screen with BlocProvider and BlocConsumer
- [ ] Error handling with AppToast
- [ ] Localization strings added
- [ ] Code generation run successfully
- [ ] Tests written (if applicable)
- [ ] Documentation updated

## Common Patterns

### For POST/PUT/DELETE Requests

Create request models:

```dart
@freezed
sealed class CreateExpenseRequest with _$CreateExpenseRequest {
  const factory CreateExpenseRequest({
    required String description,
    required double amount,
    required int categoryId,
    DateTime? date,
  }) = _CreateExpenseRequest;

  Map<String, dynamic> toJson() => {
    'description': description,
    'amount': amount,
    'categoryId': categoryId,
    if (date != null) 'date': date!.toIso8601String(),
  };
}
```

### For Params

```dart
@freezed
sealed class FilterTransactionsParams with _$FilterTransactionsParams {
  const factory FilterTransactionsParams({
    DateTime? startDate,
    DateTime? endDate,
    TransactionType? type,
    int? categoryId,
  }) = _FilterTransactionsParams;
}

extension FilterTransactionsParamsX on FilterTransactionsParams {
  Map<String, dynamic> toQueryParams() => {
    if (startDate != null) 'startDate': startDate!.toIso8601String(),
    if (endDate != null) 'endDate': endDate!.toIso8601String(),
    if (type != null) 'type': type!.name,
    if (categoryId != null) 'categoryId': categoryId,
  };
}
```

## Next Steps

After implementing a feature:
1. Test thoroughly
2. Write unit tests
3. Update documentation if needed
4. Create a pull request with semantic commit message
