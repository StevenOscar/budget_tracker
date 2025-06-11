import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<String> selectedIncomeCategories = [];
  List<String> selectedExpenseCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Activity",
          style: AppTextStyles.heading3(
            fontweight: FontWeight.w700,
            color: AppColor.mainGreen,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.mainGreen,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
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
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Total",
                            style: AppTextStyles.body2(
                              fontweight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Rp. 200.000",
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
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Transaction History",
                    style: AppTextStyles.heading4(fontweight: FontWeight.w800),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          List<String> tempSelectedIncomeCategories = List.from(
                            selectedIncomeCategories,
                          );
                          DateTime tempStartDate = startDate;
                          DateTime tempEndDate = endDate;
                          List<String> tempSelectedExpenseCategories =
                              List.from(selectedExpenseCategories);
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Center(child: Text("Filter Data")),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        "${DateFormat("d MMMM yyyy").format(tempStartDate)} - ${DateFormat("d MMMM yyyy").format(tempEndDate)}",
                                      ),
                                    ),
                                    Center(
                                      child: ElevatedButton(
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
                                        child: Text("Select Date Range"),
                                      ),
                                    ),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 5,
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
                                                  style: TextStyle(
                                                    color:
                                                        tempSelectedIncomeCategories
                                                                .contains(
                                                                  e.category,
                                                                )
                                                            ? Colors.white
                                                            : Colors
                                                                .grey
                                                                .shade600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 5,
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
                                                  style: TextStyle(
                                                    color:
                                                        tempSelectedExpenseCategories
                                                                .contains(
                                                                  e.category,
                                                                )
                                                            ? Colors.white
                                                            : Colors
                                                                .grey
                                                                .shade600,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColor.mainGreen,
                                        ),
                                        onPressed: () {},
                                        child: Text(
                                          "Save Filter",
                                          style: AppTextStyles.body2(
                                            color: Colors.white,
                                            fontweight: FontWeight.w600,
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
                    icon: Icon(
                      Icons.filter_alt_sharp,
                      color: AppColor.mainGreen,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.transactionList.length,
                itemBuilder: (context, index) {
                  return CardWidget(transaction: widget.transactionList[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
