import 'package:budget_tracker/styles/app_color.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [CircleAvatar(backgroundColor: AppColor.mainGreen)],
      ),
    );
  }
}
