import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/screens/detail_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/date_formatter.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:budget_tracker/utils/money_formatter.dart';
import 'package:budget_tracker/utils/preference_helper.dart';
import 'package:budget_tracker/widgets/card_widget.dart';
import 'package:budget_tracker/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  final List<TransactionModel> transactionList;
  final int expenseTarget;
  final Future<void> Function() loadTransaction;
  final Future<void> Function() loadUser;
  final void Function(int) changePage;
  final int balance;
  final int expense;
  final int income;
  const DashboardScreen({
    super.key,
    required this.transactionList,
    required this.loadTransaction,
    required this.changePage,
    required this.balance,
    required this.expense,
    required this.income,
    required this.loadUser,
    required this.expenseTarget,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void updateExpenseTarget() {
    final TextEditingController targetController = TextEditingController();
    bool isTargetValid = false;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (context) => PopScope(
            canPop: false,
            child: StatefulBuilder(
              builder: (BuildContext context, setState) {
                return AlertDialog(
                  content: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextFormFieldWidget(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hintText: "Target Expense",
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty || value.length > 12) {
                            isTargetValid = false;
                          } else {
                            isTargetValid = true;
                          }
                        });
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Target can't be empty ";
                        } else if (value.length > 15) {
                          return "Target is too much";
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed:
                          isTargetValid
                              ? () async {
                                String username =
                                    await PreferenceHandler.getUsername();
                                await DbHelper.updateUserTarget(
                                  username: username,
                                  target: int.parse(targetController.text),
                                );
                                widget.loadUser();
                                Navigator.pop(context);
                              }
                              : null,
                      child: Text("Set"),
                    ),
                  ],
                );
              },
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColor.mainGreen40,
                  child: Icon(
                    Icons.calendar_month_sharp,
                    color: AppColor.mainGreen,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatMonthYear(DateTime.now()),
                      style: AppTextStyles.body2(
                        fontweight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "${DateFormatter.formatDateMonthYear(DateTime(DateTime.now().year, DateTime.now().month, 1))} - ${DateFormatter.formatDateMonthYear(DateTime(DateTime.now().year, DateTime.now().month + 1, 0)).toString()}",
                      style: AppTextStyles.body3(
                        fontweight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color:
                    widget.balance >= 0
                        ? AppColor.mainGreen
                        : Colors.red.shade600,
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Balance",
                        style: AppTextStyles.body1(
                          fontweight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "Rp. ${MoneyFormatter.format(widget.balance)}",
                      style: AppTextStyles.heading3(
                        fontweight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Divider(color: Colors.white),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.trending_down_sharp,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expense",
                              style: AppTextStyles.body3(
                                fontweight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Rp. ${MoneyFormatter.format(widget.expense)}",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body2(
                                fontweight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.trending_up_sharp,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Income",
                              style: AppTextStyles.body3(
                                fontweight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Rp. ${MoneyFormatter.format(widget.income)}",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body2(
                                fontweight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColor.secondaryGreen,
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: updateExpenseTarget,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Expense target this month",
                          style: AppTextStyles.body2(
                            fontweight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Edit",
                              style: AppTextStyles.body2(
                                fontweight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios_sharp, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "Rp. ${MoneyFormatter.format(widget.expense)}",
                        style: AppTextStyles.body1(
                          fontweight: FontWeight.w800,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Expanded(
                        child: Text(
                          " / Rp. ${MoneyFormatter.format(widget.expenseTarget)}",
                          style: AppTextStyles.body1(
                            fontweight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      LayoutBuilder(
                        builder:
                            (context, constraints) => Container(
                              height: 20,
                              width:
                                  widget.expense /
                                  widget.expenseTarget *
                                  constraints.maxWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    widget.expense / widget.expenseTarget <= 0.3
                                        ? Color(0xff8cb85c)
                                        : widget.expense /
                                                widget.expenseTarget <=
                                            0.8
                                        ? Colors.orange
                                        : Colors.red.shade400,
                              ),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Recent Transaction",
                    style: AppTextStyles.heading4(fontweight: FontWeight.w800),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.changePage(1);
                      });
                    },
                    child: Text(
                      "View All",
                      style: AppTextStyles.body2(
                        fontweight: FontWeight.w500,
                        color: AppColor.mainGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            ListView.builder(
              itemCount:
                  widget.transactionList.length < 5
                      ? widget.transactionList.length
                      : 5,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailScreen(
                                loadTransaction: widget.loadTransaction,
                                transaction: widget.transactionList[index],
                              ),
                        ),
                      );
                    },
                    child: CardWidget(
                      transaction: widget.transactionList[index],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
