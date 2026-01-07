import 'dart:convert';

import 'package:extro/common/utils/transaction_type_icon.dart';
import 'package:extro/core/database/app_database.dart';
import 'package:extro/features/dashboard/data/mappers/table_data_mappers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Table Data Mappers', () {
    group('WalletTableDataMapper', () {
      test('converts WalletTableData to Wallet domain entity', () {
        const tableData = WalletTableData(
          id: 1,
          label: 'Test Wallet',
          balance: 1000.0,
          currency: 'USD',
          icon: 'card',
          accentColor: '#4A90E2',
        );

        final wallet = tableData.toDomain();

        expect(wallet.id, equals(1));
        expect(wallet.label, equals('Test Wallet'));
        expect(wallet.balance, equals(1000.0));
        expect(wallet.currency, equals('USD'));
        expect(wallet.icon, equals(TransactionTypeIcon.card.value));
        expect(wallet.accentColor, equals('#4A90E2'));
      });
    });

    group('TransactionTableDataMapper', () {
      test('converts TransactionTableData to Transaction domain entity', () {
        final dateTime = DateTime(2025, 12, 20, 9);
        final tableData = TransactionTableData(
          id: 1,
          title: 'Salary',
          transactionDateTime: dateTime,
          amount: 3500.00,
          isIncome: true,
          icon: 'dollar_sign',
          walletId: 1,
        );

        final transaction = tableData.toDomain();

        expect(transaction.id, equals(1));
        expect(transaction.title, equals('Salary'));
        expect(transaction.dateTime, equals(dateTime));
        expect(transaction.amount, equals(3500.00));
        expect(transaction.isIncome, equals(true));
        expect(transaction.icon, equals(TransactionTypeIcon.dollarSign.value));
        expect(transaction.walletId, equals(1));
      });

      test('handles expense transactions correctly', () {
        final tableData = TransactionTableData(
          id: 2,
          title: 'Grocery Shopping',
          transactionDateTime: DateTime(2025, 12, 24, 10, 30),
          amount: -85.50,
          isIncome: false,
          icon: 'cart',
          walletId: 1,
        );

        final transaction = tableData.toDomain();

        expect(transaction.amount, equals(-85.50));
        expect(transaction.isIncome, equals(false));
      });
    });

    group('SpendingChartTableDataMapper', () {
      test(
        'converts SpendingChartTableData to SpendingChart domain entity',
        () {
          final spendingData = [120.0, 85.0, 150.0, 95.0, 200.0, 175.0, 110.0];
          final tableData = SpendingChartTableData(
            id: 1,
            spendingData: jsonEncode(spendingData),
            totalAmount: '935.00',
            percentageChange: '+12.5',
          );

          final spendingChart = tableData.toDomain();

          expect(spendingChart.spendingData, equals(spendingData));
          expect(spendingChart.totalAmount, equals('935.00'));
          expect(spendingChart.percentageChange, equals('+12.5'));
        },
      );

      test('handles empty spending data', () {
        const tableData = SpendingChartTableData(
          id: 1,
          spendingData: '[]',
          totalAmount: '0.00',
          percentageChange: '0.0',
        );

        final spendingChart = tableData.toDomain();

        expect(spendingChart.spendingData, isEmpty);
        expect(spendingChart.totalAmount, equals('0.00'));
      });
    });
  });
}
