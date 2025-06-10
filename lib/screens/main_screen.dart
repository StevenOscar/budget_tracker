import 'package:budget_tracker/screens/add_screen.dart';
import 'package:budget_tracker/screens/dashboard_screen.dart';
import 'package:budget_tracker/screens/profile_screen.dart';
import 'package:budget_tracker/screens/transaction_history_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String id = "/main";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screenList = [
    DashboardScreen(),
    TransactionHistoryScreen(),
    ProfileScreen(),
  ];
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: currentPage != 2 ? Colors.white : AppColor.mainGreen,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: AppColor.mainGreen40.withAlpha(240),
          iconSize: 20,
          currentIndex: currentPage,
          onTap: (value) {
            setState(() {
              currentPage = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              label: "",
              activeIcon: Icon(
                Icons.home_outlined,
                color: AppColor.mainGreen,
                size: 36,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined, size: 30),
              label: "",
              activeIcon: Icon(
                Icons.history_outlined,
                color: AppColor.mainGreen,
                size: 36,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined, size: 30),
              label: "",
              activeIcon: Icon(
                Icons.person_outlined,
                color: AppColor.mainGreen,
                size: 36,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          currentPage == 0
              ? Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20),
                child: SizedBox(
                  height: 60,
                  width: 110,
                  child: FloatingActionButton(
                    backgroundColor: AppColor.mainGreen,
                    onPressed: () {
                      Navigator.pushNamed(context, AddScreen.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add",
                          style: AppTextStyles.body1(
                            fontweight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.add_outlined, size: 30, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              )
              : null,
      body: screenList[currentPage],
    );
  }
}
