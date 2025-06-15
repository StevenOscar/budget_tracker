import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';

class FilteredTransactionProvider extends ChangeNotifier {
  TransactionProvider transactionProvider;
  DateTime _startDate = DateTime(2000);
  DateTime _endDate = DateTime.now().add(Duration(days: 1));
  int _filteredIncome = 0;
  int _filteredBalance = 0;
  int _filteredExpense = 0;
  List<String> _selectedIncomeCategories = ["Salary", "Business", "Freelance", "Investments", "Other Incomes"];
  List<String> _selectedExpenseCategories = ["Food", "Housing", "Transportation", "Shopping", "Other Expenses"];
  List<DateTime> _uniqueDates = [];
  final Map<DateTime, List<TransactionModel>> _groupedTransactions = {};

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  int get filteredIncome => _filteredIncome;
  int get filteredExpense => _filteredExpense;
  int get filteredBalance => _filteredBalance;
  List<String> get selectedIncomeCategories => List.unmodifiable(_selectedIncomeCategories);
  List<String> get selectedExpenseCategories => List.unmodifiable(_selectedExpenseCategories);
  List<DateTime> get uniqueDates => List.unmodifiable(_uniqueDates);
  Map<DateTime, List<TransactionModel>> get groupedTransactions => Map.unmodifiable(_groupedTransactions);

  FilteredTransactionProvider(this.transactionProvider);

  Future<void> filterList({
    required List<String> tempSelectedIncomeCategories,
    required List<String> tempSelectedExpenseCategories,
    required DateTime tempStartDate,
    required DateTime tempEndDate,
  }) async {
    _selectedIncomeCategories = List.from(tempSelectedIncomeCategories);
    _selectedExpenseCategories = List.from(tempSelectedExpenseCategories);
    _startDate = tempStartDate;
    _endDate = tempEndDate;

    // Filter the transactions by date and category
    final filteredTransactions =
        transactionProvider.transactionList.where((t) {
          final tDate = DateTime(t.date.year, t.date.month, t.date.day);
          final isInDateRange =
              tDate.isAfter(_startDate.subtract(Duration(days: 1))) && tDate.isBefore(_endDate.add(Duration(days: 1)));
          final isIncome = t.type == 1 && (_selectedIncomeCategories.contains(t.category));
          final isExpense = t.type == 0 && (_selectedExpenseCategories.contains(t.category));
          return isInDateRange && (isIncome || isExpense);
        }).toList();

    // Calculate totals
    _filteredIncome = filteredTransactions.where((t) => t.type == 1).fold(0, (sum, t) => sum + t.amount);

    _filteredExpense = filteredTransactions.where((t) => t.type == 0).fold(0, (sum, t) => sum + t.amount);

    _filteredBalance = _filteredIncome - _filteredExpense;

    // Group transactions by unique dates
    _uniqueDates =
        filteredTransactions.map((t) => DateTime(t.date.year, t.date.month, t.date.day)).toSet().toList()
          ..sort((a, b) => a.compareTo(b));

    _groupedTransactions.clear();
    for (var date in _uniqueDates) {
      _groupedTransactions[date] =
          filteredTransactions.where((t) {
            final tDate = DateTime(t.date.year, t.date.month, t.date.day);
            return tDate == date;
          }).toList();
    }
    notifyListeners();
  }
}
