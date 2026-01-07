import 'dart:convert';

import 'package:extro/core/database/app_database.dart';

import '../../domain/entities/spending_chart.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/entities/wallet.dart';

extension WalletTableDataMapper on WalletTableData {
  Wallet toDomain() {
    return Wallet(
      id: id,
      label: label,
      balance: balance,
      currency: currency,
      icon: icon,
      accentColor: accentColor,
    );
  }
}

extension TransactionTableDataMapper on TransactionTableData {
  Transaction toDomain() {
    return Transaction(
      id: id,
      title: title,
      dateTime: transactionDateTime,
      amount: amount,
      isIncome: isIncome,
      icon: icon,
      walletId: walletId,
    );
  }
}

extension SpendingChartTableDataMapper on SpendingChartTableData {
  SpendingChart toDomain() {
    final List<double> parsedData = (jsonDecode(spendingData) as List)
        .map((e) => (e as num).toDouble())
        .toList();
    return SpendingChart(
      spendingData: parsedData,
      totalAmount: totalAmount,
      percentageChange: percentageChange,
    );
  }
}
