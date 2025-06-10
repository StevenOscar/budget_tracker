import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final int index;
  const CardWidget({super.key, required this.index});

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
        leading: Icon(Icons.receipt_long_sharp),
        title: Text(
          "Rent",
          style: AppTextStyles.body2(
            fontweight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          "10 June 25",
          style: AppTextStyles.body2(fontweight: FontWeight.w400),
        ),
        trailing: Text(
          index % 2 == 0 ? "+ Rp.20.000" : "- Rp.200.000",
          style: AppTextStyles.body2(
            fontweight: FontWeight.w800,
            color: index % 2 == 0 ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
