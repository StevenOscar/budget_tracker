import 'package:budget_tracker/constants/assets_images.dart';
import 'package:budget_tracker/screens/main_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = "/";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.id,
        (route) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainGreen,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Colors.white,
          ),
          padding: EdgeInsets.only(left: 60, right: 60, top: 44, bottom: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AssetsImages.appLogoCropped, width: 180, height: 180),
              SizedBox(height: 16),
              Text(
                "Ka\$pot",
                style: AppTextStyles.heading1(
                  fontweight: FontWeight.w700,
                  color: AppColor.mainGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
