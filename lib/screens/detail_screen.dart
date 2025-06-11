import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/date_formatter.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:budget_tracker/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  static const String id = "/detail";
  final Future<void> Function() loadTransaction;
  final int userId;
  const DetailScreen({
    super.key,
    required this.loadTransaction,
    required this.userId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // TODO Create Detail & Edit Screen
  int transactionType = 0;
  bool isEdit = false;
  String selectedCategory = "Food";
  DateTime dateValue = DateTime.now();
  TimeOfDay timeValue = TimeOfDay.now();
  final TextEditingController amountController = TextEditingController();
  bool isAmountValid = false;
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: CircleAvatar(
              radius: 20,
              backgroundColor: AppColor.mainGreen40,
              child: Icon(
                Icons.arrow_back,
                size: 28,
                color: AppColor.mainGreen,
              ),
            ),
          ),
        ),
        title: Text(
          "Detail Transaction",
          style: AppTextStyles.heading3(
            fontweight: FontWeight.w700,
            color: AppColor.mainGreen,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.mainGreen40,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month,
                                color: AppColor.mainGreen,
                              ),
                              SizedBox(width: 8),
                              Text(
                                DateFormatter.formatDayDateMonthYear(dateValue),
                                style: AppTextStyles.body1(
                                  fontweight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.alarm, color: AppColor.mainGreen),
                              SizedBox(width: 8),
                              Text(
                                "${timeValue.hour.toString()}:${timeValue.minute.toString().padLeft(2, '0')}",
                                style: AppTextStyles.body1(
                                  fontweight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainGreen,
                                ),
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: dateValue,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                      );
                                  if (selectedDate != null) {
                                    setState(() {
                                      dateValue = selectedDate;
                                    });
                                  }
                                },
                                child: Text(
                                  "Select Date",
                                  style: AppTextStyles.body2(
                                    fontweight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.mainGreen,
                                ),
                                onPressed: () async {
                                  final TimeOfDay? selectedTime =
                                      await showTimePicker(
                                        context: context,
                                        initialTime: timeValue,
                                      );
                                  if (selectedTime != null) {
                                    setState(() {
                                      timeValue = selectedTime;
                                    });
                                  }
                                },
                                child: Text(
                                  "Select Time",
                                  style: AppTextStyles.body2(
                                    fontweight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Radio(
                  activeColor: AppColor.mainGreen,
                  value: 0,
                  groupValue: transactionType,
                  onChanged: (value) {
                    setState(() {
                      transactionType = value!;
                      selectedCategory = "Food";
                    });
                  },
                ),
                Text(
                  "Expense",
                  style: AppTextStyles.body1(
                    fontweight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 20),
                Radio(
                  value: 1,
                  activeColor: AppColor.mainGreen,
                  groupValue: transactionType,
                  onChanged: (value) {
                    setState(() {
                      transactionType = value!;
                      selectedCategory = "Salary";
                    });
                  },
                ),
                Text(
                  "Income",
                  style: AppTextStyles.body1(
                    fontweight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            TextFormFieldWidget(
              controller: amountController,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, top: 14, bottom: 15),
                child: Text(
                  "Rp.  ",
                  style: AppTextStyles.body1(
                    fontweight: FontWeight.w700,
                    color: AppColor.mainGreen,
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty || value.length > 12) {
                    isAmountValid = false;
                  } else {
                    isAmountValid = true;
                  }
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return "Amount can't be empty ";
                } else if (value.length > 12) {
                  return "Amount can't be higher than 12 digit";
                }
                return null;
              },
              contentPadding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: 16,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(r'[+!@#$%^&*(),.?":{}|<>]]'),
                ),
                FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
              ],
              hintText: "Amount",
            ),
            SizedBox(height: isAmountValid ? 35 : 12),
            TextFormFieldWidget(
              controller: notesController,
              maxlines: 3,
              prefixIcon: Icon(Icons.note, size: 25, color: AppColor.mainGreen),
              hintText: "Note (Optional)",
            ),
            SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColor.mainGreen40,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black.withAlpha(50), width: 1),
              ),
              width: double.infinity,
              child: DropdownButton(
                value: selectedCategory,
                isExpanded: true,
                padding: EdgeInsets.symmetric(horizontal: 12),
                dropdownColor: Colors.white,
                underline: SizedBox(),
                iconEnabledColor: AppColor.mainGreen,
                alignment: Alignment.center,
                items:
                    transactionType == 0
                        ? expenseCategories
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.category,
                                child: Row(
                                  children: [
                                    Icon(e.icon, color: AppColor.mainGreen),
                                    SizedBox(width: 20),
                                    Text(
                                      e.category,
                                      style: AppTextStyles.body1(
                                        fontweight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                        : incomeCategories
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.category,
                                child: Row(
                                  children: [
                                    Icon(e.icon, color: AppColor.mainGreen),
                                    SizedBox(width: 20),
                                    Text(
                                      e.category,
                                      style: AppTextStyles.body1(
                                        fontweight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainGreen,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed:
                    isAmountValid
                        ? () async {
                          await DbHelper.insertTransactionData(
                            data: TransactionModel(
                              userId: widget.userId,
                              amount: int.parse(amountController.text),
                              note: notesController.text,
                              type: transactionType,
                              category: selectedCategory,
                              date: dateValue,
                              time: timeValue,
                            ),
                          );
                          widget.loadTransaction();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColor.mainGreen,
                              content: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Text(
                                    "Transaction saved",
                                    style: AppTextStyles.body1(
                                      fontweight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                        : null,
                child: Text(
                  "Submit",
                  style: AppTextStyles.body1(
                    fontweight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
