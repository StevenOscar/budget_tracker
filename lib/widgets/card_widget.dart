import 'package:budget_tracker/models/category_model.dart';
import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatelessWidget {
  final TransactionModel transaction;
  const CardWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColor.mainGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        tileColor: Colors.white,
        leading: Icon(
          (transaction.type == 0 ? expenseCategories : incomeCategories)
              .firstWhere((element) => element.category == transaction.category)
              .icon,
          color: transaction.type == 0 ? Colors.red : AppColor.mainGreen,
          size: 35,
        ),
        title: Text(
          transaction.category,
          style: AppTextStyles.body2(
            fontweight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          "${DateFormat('d MMMM yyyy').format(transaction.date)} ${transaction.time.hour.toString()}:${transaction.time.minute.toString().padLeft(2, '0')}",
          style: AppTextStyles.body2(fontweight: FontWeight.w400),
        ),
        trailing: Text(
          transaction.type == 0
              ? "- Rp.${transaction.amount}"
              : "+ Rp.${transaction.amount}",
          style: AppTextStyles.body2(
            fontweight: FontWeight.w800,
            color: transaction.type == 0 ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}
