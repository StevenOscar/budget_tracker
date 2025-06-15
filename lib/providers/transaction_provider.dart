import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:budget_tracker/utils/preference_helper.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  List<TransactionModel> _transactionList = [];
  int _balance = 0;
  int _expense = 0;
  int _totalMonthlyExpense = 0;
  int _income = 0;

  List<TransactionModel> get transactionList => _transactionList;
  int get balance => _balance;
  int get expense => _expense;
  int get totalMonthlyExpense => _totalMonthlyExpense;
  int get income => _income;

  Future<void> loadTransaction() async {
    int userId = await PreferenceHandler.getUserId();
    final data = await DbHelper.getTransactionData(userId: userId);
    if (data.isNotEmpty) {
      _balance = 0;
      _expense = 0;
      _income = 0;
      _totalMonthlyExpense = 0;
      _transactionList = data;
      transactionList.sort((a, b) => b.date.compareTo(a.date));
      for (int i = 0; i < transactionList.length; i++) {
        if (transactionList[i].date.isAfter(
              DateTime(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 1)),
            ) &&
            transactionList[i].date.isBefore(
              DateTime(DateTime.now().year, DateTime.now().month + 1, 0).add(Duration(days: 1)),
            )) {
          if (transactionList[i].type == 0) {
            _balance -= transactionList[i].amount;
            _expense += transactionList[i].amount;
            _totalMonthlyExpense += transactionList[i].amount;
          } else {
            _balance += transactionList[i].amount;
            _income += transactionList[i].amount;
          }
        }
      }
    } else {
      _transactionList = [];
      _balance = 0;
      _totalMonthlyExpense = 0;
      _expense = 0;
      _income = 0;
    }
    notifyListeners();
  }
}
