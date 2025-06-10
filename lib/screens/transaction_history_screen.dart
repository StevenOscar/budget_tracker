import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/widgets/card_widget.dart';
import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String id = "/history";
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  DateTime startDate = DateTime(2000);
  DateTime endDate = DateTime(2000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Transaction History"),
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
                          Text("Expense"),
                          Text("Rp. 800.000", overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Income"),
                          Text(
                            "Rp. 1.000.000.000000",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Total"),
                          Text("Rp. 200.000", overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
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
                          List<String> selectedIncomeCategories = [];
                          List<String> selectedExpenseCategories = [];
                          return AlertDialog(
                            title: Text("Filter Data"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final DateTimeRange? selectedDateRange =
                                        await showDateRangePicker(
                                          context: context,

                                          firstDate: DateTime(2000),
                                          barrierColor: Colors.white,
                                          lastDate: DateTime.now(),
                                        );
                                    if (selectedDateRange != null) {
                                      startDate = selectedDateRange.start;
                                      endDate = selectedDateRange.end;
                                    }
                                  },
                                  child: Text("Select Date Range"),
                                ),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.start,
                                  children:
                                      incomeCategories.map((e) {
                                        return Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          backgroundColor: AppColor.mainGreen,
                                          label: Text(
                                            e.category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.start,
                                  children:
                                      expenseCategories.map((e) {
                                        return Chip(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          backgroundColor: AppColor.mainGreen,
                                          label: Text(
                                            e.category,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
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
                itemCount: 10,
                itemBuilder: (context, index) {
                  return CardWidget(index: index);
                },
              ),
              ElevatedButton(onPressed: () {}, child: Text("Filter")),
            ],
          ),
        ),
      ),
    );
  }
}
