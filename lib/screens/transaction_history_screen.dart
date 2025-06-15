import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/models/user_model.dart';
import 'package:budget_tracker/providers/filtered_transaction_provider.dart';
import 'package:budget_tracker/providers/transaction_provider.dart';
import 'package:budget_tracker/screens/detail_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/date_formatter.dart';
import 'package:budget_tracker/utils/money_formatter.dart';
import 'package:budget_tracker/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static String id = "/history";
  final UserModel userData;

  const TransactionHistoryScreen({super.key, required this.userData});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filtTransactionProvider = context.read<FilteredTransactionProvider>();
      filtTransactionProvider.filterList(
        tempSelectedIncomeCategories: ["Salary", "Business", "Freelance", "Investments", "Other Incomes"],
        tempSelectedExpenseCategories: ["Food", "Housing", "Transportation", "Shopping", "Other Expenses"],
        tempStartDate: DateTime(2000),
        tempEndDate: DateTime.now().add(Duration(days: 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider = context.watch<TransactionProvider>();
    FilteredTransactionProvider filtTransactionProvider = context.watch<FilteredTransactionProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(35, 30))),
        title: Text("Activity", style: AppTextStyles.heading3(fontweight: FontWeight.w700, color: Colors.white)),
        toolbarHeight: 70,
        centerTitle: true,
        backgroundColor: AppColor.mainGreen,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          filtTransactionProvider.filterList(
            tempSelectedIncomeCategories: filtTransactionProvider.selectedIncomeCategories,
            tempSelectedExpenseCategories: filtTransactionProvider.selectedExpenseCategories,
            tempStartDate: filtTransactionProvider.startDate,
            tempEndDate: filtTransactionProvider.endDate,
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
                          Text("Transaction History", style: AppTextStyles.heading4(fontweight: FontWeight.w800)),
                          Text(
                            "${DateFormatter.formatDateMonthYear(filtTransactionProvider.startDate)} - ${DateFormatter.formatDateMonthYear(filtTransactionProvider.endDate)}",
                            style: AppTextStyles.body2(fontweight: FontWeight.w500, color: Colors.black),
                          ),
                        ],
                      ),
                      IconButton(
                        style: IconButton.styleFrom(backgroundColor: AppColor.mainGreen),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              List<String> tempSelectedIncomeCategories = List.from(
                                filtTransactionProvider.selectedIncomeCategories,
                              );
                              List<String> tempSelectedExpenseCategories = List.from(
                                filtTransactionProvider.selectedExpenseCategories,
                              );
                              DateTime tempStartDate = filtTransactionProvider.startDate;
                              DateTime tempEndDate = filtTransactionProvider.endDate;
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
                                              side: BorderSide(color: AppColor.mainGreen, width: 1),
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () async {
                                              final DateTimeRange? selectedDateRange = await showDateRangePicker(
                                                context: context,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now(),
                                              );
                                              if (selectedDateRange != null) {
                                                setState(() {
                                                  tempStartDate = selectedDateRange.start;
                                                  tempEndDate = selectedDateRange.end;
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
                                                      if (tempSelectedIncomeCategories.contains(e.category)) {
                                                        tempSelectedIncomeCategories.remove(e.category);
                                                      } else {
                                                        tempSelectedIncomeCategories.add(e.category);
                                                      }
                                                    });
                                                  },
                                                  child: Chip(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    backgroundColor:
                                                        tempSelectedIncomeCategories.contains(e.category)
                                                            ? AppColor.mainGreen
                                                            : Colors.white,
                                                    label: Text(
                                                      e.category,
                                                      style: AppTextStyles.body2(
                                                        fontweight: FontWeight.w600,
                                                        color:
                                                            tempSelectedIncomeCategories.contains(e.category)
                                                                ? Colors.white
                                                                : Colors.grey.shade600,
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
                                                      if (tempSelectedExpenseCategories.contains(e.category)) {
                                                        tempSelectedExpenseCategories.remove(e.category);
                                                      } else {
                                                        tempSelectedExpenseCategories.add(e.category);
                                                      }
                                                    });
                                                  },
                                                  child: Chip(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    backgroundColor:
                                                        tempSelectedExpenseCategories.contains(e.category)
                                                            ? Colors.red
                                                            : Colors.white,
                                                    label: Text(
                                                      e.category,
                                                      style: AppTextStyles.body2(
                                                        fontweight: FontWeight.w600,
                                                        color:
                                                            tempSelectedExpenseCategories.contains(e.category)
                                                                ? Colors.white
                                                                : Colors.grey.shade600,
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
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColor.mainGreen),
                                            onPressed: () {
                                              filtTransactionProvider.filterList(
                                                tempSelectedExpenseCategories: tempSelectedExpenseCategories,
                                                tempSelectedIncomeCategories: tempSelectedIncomeCategories,
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
                  filtTransactionProvider.selectedIncomeCategories.isEmpty &&
                          filtTransactionProvider.selectedExpenseCategories.isEmpty
                      ? SizedBox()
                      : Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount:
                                filtTransactionProvider.selectedIncomeCategories.length +
                                filtTransactionProvider.selectedExpenseCategories.length,
                            itemBuilder: (context, index) {
                              List<String> categories = [
                                ...filtTransactionProvider.selectedIncomeCategories,
                                ...filtTransactionProvider.selectedExpenseCategories,
                              ];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Chip(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  backgroundColor:
                                      filtTransactionProvider.selectedIncomeCategories.contains(categories[index])
                                          ? AppColor.mainGreen
                                          : Colors.red,
                                  label: Text(
                                    categories[index],
                                    style: AppTextStyles.body2(fontweight: FontWeight.w600, color: Colors.white),
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
                      color: filtTransactionProvider.filteredBalance >= 0 ? AppColor.mainGreen : Colors.red,
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
                                    style: AppTextStyles.body2(fontweight: FontWeight.w500, color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Rp. ${MoneyFormatter.format(filtTransactionProvider.filteredExpense)}",
                                    style: AppTextStyles.body2(fontweight: FontWeight.w700, color: Colors.white),
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
                                    style: AppTextStyles.body2(fontweight: FontWeight.w500, color: Colors.white),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Rp. ${MoneyFormatter.format(filtTransactionProvider.filteredIncome)}",
                                    style: AppTextStyles.body2(fontweight: FontWeight.w700, color: Colors.white),
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
                            Text("Total", style: AppTextStyles.body1(fontweight: FontWeight.w800, color: Colors.white)),
                            SizedBox(width: 8),
                            Text(
                              "${filtTransactionProvider.filteredBalance >= 0 ? '+ ' : ''}Rp. ${MoneyFormatter.format(filtTransactionProvider.filteredBalance)}",
                              style: AppTextStyles.body1(fontweight: FontWeight.w800, color: Colors.white),
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
                    itemCount: filtTransactionProvider.uniqueDates.length,
                    itemBuilder: (context, index) {
                      final date = filtTransactionProvider.uniqueDates[index];
                      final dateTransactions = filtTransactionProvider.groupedTransactions[date]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormatter.formatDayDateMonthYear(date),
                            style: AppTextStyles.heading4(fontweight: FontWeight.w700, color: Colors.black),
                          ),
                          ...dateTransactions.map(
                            (tx) => GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DetailScreen(transaction: tx)),
                                ).then((value) async {
                                  await transactionProvider.loadTransaction();
                                  await filtTransactionProvider.filterList(
                                    tempSelectedIncomeCategories: filtTransactionProvider.selectedIncomeCategories,
                                    tempSelectedExpenseCategories: filtTransactionProvider.selectedExpenseCategories,
                                    tempStartDate: filtTransactionProvider.startDate,
                                    tempEndDate: filtTransactionProvider.endDate,
                                  );
                                });
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
