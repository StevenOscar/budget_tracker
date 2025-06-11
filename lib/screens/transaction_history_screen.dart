import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/date_formatter.dart';
import 'package:budget_tracker/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String id = "/history";
  final List<TransactionModel> transactionList;
  final Future<void> Function() loadTransaction;

  const TransactionHistoryScreen({
    super.key,
    required this.transactionList,
    required this.loadTransaction,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime startDate = DateTime(2000);
  DateTime endDate = DateTime.now();
  int currIncome = 0;
  int currBalance = 0;
  int currExpense = 0;
  List<String> selectedIncomeCategories = [];
  List<String> selectedExpenseCategories = [];
  List<DateTime> uniqueDates = [];
  Map<DateTime, List<TransactionModel>> groupedTransactions = {};

  // void filterList() {
  //   // TODO Create filter
  //   final uniqueDates = widget.transactionList
  //       .map((t) => DateTime(t.date.year, t.date.month, t.date.day))
  //       .toSet()
  //       .toList()
  //       .sort((a, b) => a.compareTo(b));

  //   for (var date in uniqueDates) {
  //     groupedTransactions[date] =
  //         widget.transactionList.where((t) {
  //           final tDate = DateTime(t.date.year, t.date.month, t.date.day);
  //           return tDate == date;
  //         }).toList();
  //   }
  // }

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
      body: SingleChildScrollView(
        child: Padding(
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
                          List<String> tempSelectedIncomeCategories = List.from(
                            selectedIncomeCategories,
                          );
                          List<String> tempSelectedExpenseCategories =
                              List.from(selectedExpenseCategories);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        "${DateFormatter.formatDateMonthYear(tempStartDate)} - ${DateFormatter.formatDateMonthYear(tempEndDate)}",
                                        style: AppTextStyles.body1(
                                          fontweight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.mainGreen,
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
                                            color: Colors.white,
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
                                                      .contains(e.category)) {
                                                    tempSelectedIncomeCategories
                                                        .remove(e.category);
                                                  } else {
                                                    tempSelectedIncomeCategories
                                                        .add(e.category);
                                                  }
                                                });
                                              },
                                              child: Chip(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
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
                                                    fontweight: FontWeight.w600,
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
                                                      .contains(e.category)) {
                                                    tempSelectedExpenseCategories
                                                        .remove(e.category);
                                                  } else {
                                                    tempSelectedExpenseCategories
                                                        .add(e.category);
                                                  }
                                                });
                                              },
                                              child: Chip(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                backgroundColor:
                                                    tempSelectedExpenseCategories
                                                            .contains(
                                                              e.category,
                                                            )
                                                        ? AppColor.mainGreen
                                                        : Colors.white,
                                                label: Text(
                                                  e.category,
                                                  style: AppTextStyles.body2(
                                                    fontweight: FontWeight.w600,
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
                                          backgroundColor: AppColor.mainGreen,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedExpenseCategories =
                                                List.from(
                                                  tempSelectedExpenseCategories,
                                                );
                                            selectedExpenseCategories =
                                                List.from(
                                                  tempSelectedExpenseCategories,
                                                );
                                            startDate = tempStartDate;
                                            endDate = tempEndDate;
                                          });
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
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.mainGreen,
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
                                "Rp. 800.000",
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
                                "Rp. 1.000.000.000000",
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
                          "${currBalance >= 0 ? '+' : '-'}Rp. 200.000",
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ...dateTransactions.map(
                        (tx) => CardWidget(
                          transaction: widget.transactionList[index],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
