import 'package:budget_tracker/models/user_model.dart';
import 'package:budget_tracker/screens/login_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/preference_helper.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel userData;

  const ProfileScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColor.mainGreen,
      appBar: AppBar(
        title: Text("Profile", style: AppTextStyles.heading3(fontweight: FontWeight.w700, color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppColor.mainGreen,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          padding: EdgeInsets.all(28),
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColor.mainGreen,
                    child: CircleAvatar(
                      radius: 29,
                      backgroundColor: AppColor.mainGreen40,
                      child: Text(
                        userData.name[0],
                        style: AppTextStyles.heading3(fontweight: FontWeight.w600, color: AppColor.mainGreen),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData.name, style: AppTextStyles.body1(fontweight: FontWeight.w600, color: Colors.black)),
                      Text(
                        "Username : ${userData.username}",
                        style: AppTextStyles.body2(fontweight: FontWeight.w600, color: Colors.grey.shade700),
                      ),
                      Text(
                        "Phone : ${userData.phoneNumber}",
                        style: AppTextStyles.body2(fontweight: FontWeight.w600, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: () async {
                    PreferenceHandler.deleteUserId();
                    PreferenceHandler.deleteLogin();
                    Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
                  },
                  child: Text("Log out", style: AppTextStyles.body1(fontweight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
