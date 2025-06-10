import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/widgets/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatefulWidget {
  static const String id = "/add";
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int transactionType = 0;
  String selectedCategory = "Food";
  DateTime dateValue = DateTime.now();
  TimeOfDay timeValue = TimeOfDay.now();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              radius: 18,
              backgroundColor: AppColor.mainGreen40,
              child: Icon(Icons.arrow_back, color: AppColor.mainGreen),
            ),
          ),
        ),
        title: Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_month, color: AppColor.mainGreen),
                          SizedBox(width: 12),
                          Text(
                            DateFormat(
                              "EEEE, d MMMM yyyy",
                              "EN_en",
                            ).format(dateValue),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.alarm, color: AppColor.mainGreen),
                          SizedBox(width: 12),
                          Text(
                            "${timeValue.hour.toString()}:${timeValue.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
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
                            final DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: dateValue,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                dateValue = selectedDate;
                              });
                            }
                          },
                          child: Text(
                            "Select Date",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
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
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
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
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
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
              contentPadding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: 16,
              ),
              inputFormatters: [
                CurrencyInputFormatter(
                  thousandSeparator: ThousandSeparator.Period,
                  mantissaLength: 0,
                  trailingSymbol: "",
                ),
              ],
              hintText: "Amount",
            ),
            SizedBox(height: 12),
            TextFormFieldWidget(
              controller: notesController,
              maxlines: 3,
              prefixIcon: Icon(Icons.note, size: 25, color: AppColor.mainGreen),
              hintText: "Note",
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
                                    Text(e.category),
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
                                    Text(e.category),
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
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainGreen,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
