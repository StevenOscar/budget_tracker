import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/models/user_model.dart';
import 'package:budget_tracker/screens/detail_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/date_formatter.dart';
import 'package:budget_tracker/utils/money_formatter.dart';
import 'package:budget_tracker/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String id = "/history";
  final List<TransactionModel> transactionList;
  final UserModel userData;
  final Future<void> Function() loadTransaction;

  const TransactionHistoryScreen({
    super.key,
    required this.transactionList,
    required this.loadTransaction,
    required this.userData,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime startDate = DateTime(2000);
  DateTime endDate = DateTime.now().add(Duration(days: 1));
  int currIncome = 0;
  int currBalance = 0;
  int currExpense = 0;
  List<String> selectedIncomeCategories = [
    "Salary",
    "Business",
    "Freelance",
    "Investments",
    "Other Incomes",
  ];
  List<String> selectedExpenseCategories = [
    "Food",
    "Housing",
    "Transportation",
    "Shopping",
    "Other Expenses",
  ];
  List<DateTime> uniqueDates = [];
  Map<DateTime, List<TransactionModel>> groupedTransactions = {};

  @override
  void initState() {
    filterList(
      tempSelectedIncomeCategories: selectedIncomeCategories,
      tempSelectedExpenseCategories: selectedExpenseCategories,
      tempStartDate: startDate,
      tempEndDate: endDate,
    );
    super.initState();
  }

  void filterList({
    required List<String> tempSelectedIncomeCategories,
    required List<String> tempSelectedExpenseCategories,
    required DateTime tempStartDate,
    required DateTime tempEndDate,
  }) {
    setState(() {
      selectedIncomeCategories = List.from(tempSelectedIncomeCategories);
      selectedExpenseCategories = List.from(tempSelectedExpenseCategories);
      startDate = tempStartDate;
      endDate = tempEndDate;

      // Filter the transactions by date and category
      final filteredTransactions =
          widget.transactionList.where((t) {
            final tDate = DateTime(t.date.year, t.date.month, t.date.day);
            final isInDateRange =
                tDate.isAfter(startDate.subtract(Duration(days: 1))) &&
                tDate.isBefore(endDate.add(Duration(days: 1)));
            final isIncome =
                t.type == 1 && (selectedIncomeCategories.contains(t.category));
            final isExpense =
                t.type == 0 && (selectedExpenseCategories.contains(t.category));
            return isInDateRange && (isIncome || isExpense);
          }).toList();

      for (int i = 0; i < filteredTransactions.length; i++) {
        print(filteredTransactions[i].category);
      }
      // Calculate totals
      currIncome = filteredTransactions
          .where((t) => t.type == 1)
          .fold(0, (sum, t) => sum + t.amount);

      currExpense = filteredTransactions
          .where((t) => t.type == 0)
          .fold(0, (sum, t) => sum + t.amount);

      currBalance = currIncome - currExpense;

      // Group transactions by unique dates
      uniqueDates =
          filteredTransactions
              .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
              .toSet()
              .toList()
            ..sort((a, b) => a.compareTo(b));

      groupedTransactions.clear();
      for (var date in uniqueDates) {
        groupedTransactions[date] =
            filteredTransactions.where((t) {
              final tDate = DateTime(t.date.year, t.date.month, t.date.day);
              return tDate == date;
            }).toList();
      }
    });
  }

  Future<void> loadTransaction() async {
    await widget.loadTransaction();
    filterList(
      tempSelectedIncomeCategories: selectedIncomeCategories,
      tempSelectedExpenseCategories: selectedExpenseCategories,
      tempStartDate: startDate,
      tempEndDate: endDate,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(35, 30),
          ),
        ),
        title: Text(
          "Activity",
          style: AppTextStyles.heading3(
            fontweight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: AppColor.mainGreen,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          filterList(
            tempSelectedIncomeCategories: selectedIncomeCategories,
            tempSelectedExpenseCategories: selectedExpenseCategories,
            tempStartDate: startDate,
            tempEndDate: endDate,
          );
        },
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transaction History",
                            style: AppTextStyles.heading4(
                              fontweight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "${DateFormatter.formatDateMonthYear(startDate)} - ${DateFormatter.formatDateMonthYear(endDate)}",
                            style: AppTextStyles.body2(
                              fontweight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: AppColor.mainGreen,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              List<String> tempSelectedIncomeCategories =
                                  List.from(selectedIncomeCategories);
                              List<String> tempSelectedExpenseCategories =
                                  List.from(selectedExpenseCategories);
                              print(tempSelectedExpenseCategories);
                              print(tempSelectedIncomeCategories);
                              DateTime tempStartDate = startDate;
                              DateTime tempEndDate = endDate;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: Center(
                                      child: Text(
                                        "Filter Data",
                                        style: AppTextStyles.heading2(
                                          fontweight: FontWeight.w700,
                                          color: AppColor.mainGreen,
                                        ),
                                      ),
                                    ),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Text(
                                            "${DateFormatter.formatDateMonthYear(tempStartDate)} - ${DateFormatter.formatDateMonthYear(tempEndDate)}",
                                            style: AppTextStyles.body1(
                                              fontSize: 16,
                                              fontweight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                color: AppColor.mainGreen,
                                                width: 1,
                                              ),
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () async {
                                              final DateTimeRange?
                                              selectedDateRange =
                                                  await showDateRangePicker(
                                                    context: context,
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime.now(),
                                                  );
                                              if (selectedDateRange != null) {
                                                setState(() {
                                                  tempStartDate =
                                                      selectedDateRange.start;
                                                  tempEndDate =
                                                      selectedDateRange.end;
                                                });
                                              }
                                            },
                                            child: Text(
                                              "Select Date Range",
                                              style: AppTextStyles.body2(
                                                color: AppColor.mainGreen,
                                                fontweight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Center(
                                          child: Text(
                                            "Income",
                                            style: AppTextStyles.heading4(
                                              fontweight: FontWeight.w700,
                                              color: AppColor.mainGreen,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          alignment: WrapAlignment.start,
                                          children:
                                              incomeCategories.map((e) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (tempSelectedIncomeCategories
                                                          .contains(
                                                            e.category,
                                                          )) {
                                                        tempSelectedIncomeCategories
                                                            .remove(e.category);
                                                      } else {
                                                        tempSelectedIncomeCategories
                                                            .add(e.category);
                                                        print(
                                                          tempSelectedIncomeCategories,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Chip(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    backgroundColor:
                                                        tempSelectedIncomeCategories
                                                                .contains(
                                                                  e.category,
                                                                )
                                                            ? AppColor.mainGreen
                                                            : Colors.white,
                                                    label: Text(
                                                      e.category,
                                                      style: AppTextStyles.body2(
                                                        fontweight:
                                                            FontWeight.w600,
                                                        color:
                                                            tempSelectedIncomeCategories
                                                                    .contains(
                                                                      e.category,
                                                                    )
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey
                                                                    .shade600,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        SizedBox(height: 12),
                                        Center(
                                          child: Text(
                                            "Expense",
                                            style: AppTextStyles.heading4(
                                              fontweight: FontWeight.w700,
                                              color: AppColor.mainGreen,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Wrap(
                                          spacing: 4,
                                          runSpacing: 2,
                                          alignment: WrapAlignment.start,
                                          children:
                                              expenseCategories.map((e) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      if (tempSelectedExpenseCategories
                                                          .contains(
                                                            e.category,
                                                          )) {
                                                        tempSelectedExpenseCategories
                                                            .remove(e.category);
                                                      } else {
                                                        tempSelectedExpenseCategories
                                                            .add(e.category);
                                                        print(
                                                          tempSelectedExpenseCategories,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Chip(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    backgroundColor:
                                                        tempSelectedExpenseCategories
                                                                .contains(
                                                                  e.category,
                                                                )
                                                            ? Colors.red
                                                            : Colors.white,
                                                    label: Text(
                                                      e.category,
                                                      style: AppTextStyles.body2(
                                                        fontweight:
                                                            FontWeight.w600,
                                                        color:
                                                            tempSelectedExpenseCategories
                                                                    .contains(
                                                                      e.category,
                                                                    )
                                                                ? Colors.white
                                                                : Colors
                                                                    .grey
                                                                    .shade600,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                        SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColor.mainGreen,
                                            ),
                                            onPressed: () {
                                              filterList(
                                                tempSelectedExpenseCategories:
                                                    tempSelectedExpenseCategories,
                                                tempSelectedIncomeCategories:
                                                    tempSelectedIncomeCategories,
                                                tempStartDate: tempStartDate,
                                                tempEndDate: tempEndDate,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Save Filter",
                                              style: AppTextStyles.body2(
                                                color: Colors.white,
                                                fontweight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.filter_alt_sharp, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  selectedIncomeCategories.isEmpty &&
                          selectedExpenseCategories.isEmpty
                      ? SizedBox()
                      : Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                                selectedIncomeCategories.length +
                                selectedExpenseCategories.length,
                            itemBuilder: (context, index) {
                              List<String> categories = [
                                ...selectedIncomeCategories,
                                ...selectedExpenseCategories,
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor:
                                      selectedIncomeCategories.contains(
                                            categories[index],
                                          )
                                          ? AppColor.mainGreen
                                          : Colors.red,
                                  label: Text(
                                    categories[index],
                                    style: AppTextStyles.body2(
                                      fontweight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currBalance >= 0 ? AppColor.mainGreen : Colors.red,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Expense",
                                    style: AppTextStyles.body2(
                                      fontweight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Rp. ${MoneyFormatter.format(currExpense)}",
                                    style: AppTextStyles.body2(
                                      fontweight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "Income",
                                    style: AppTextStyles.body2(
                                      fontweight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Rp. ${MoneyFormatter.format(currIncome)}",
                                    style: AppTextStyles.body2(
                                      fontweight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total",
                              style: AppTextStyles.body1(
                                fontweight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              "${currBalance >= 0 ? '+ ' : ''}Rp. ${MoneyFormatter.format(currBalance)}",
                              style: AppTextStyles.body1(
                                fontweight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: uniqueDates.length,
                    itemBuilder: (context, index) {
                      final date = uniqueDates[index];
                      final dateTransactions = groupedTransactions[date]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormatter.formatDayDateMonthYear(date),
                            style: AppTextStyles.heading4(
                              fontweight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          ...dateTransactions.map(
                            (tx) => GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailScreen(
                                          transaction: tx,
                                          loadTransaction: loadTransaction,
                                        ),
                                  ),
                                );
                                await loadTransaction();
                              },
                              child: CardWidget(transaction: tx),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
