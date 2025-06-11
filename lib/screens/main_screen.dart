import 'package:budget_tracker/models/transaction_model.dart';
import 'package:budget_tracker/models/user_model.dart';
import 'package:budget_tracker/screens/add_screen.dart';
import 'package:budget_tracker/screens/dashboard_screen.dart';
import 'package:budget_tracker/screens/profile_screen.dart';
import 'package:budget_tracker/screens/transaction_history_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String id = "/main";
  final UserModel userData;
  const MainScreen({super.key, required this.userData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<TransactionModel> transactionList = [];
  List<Widget> screenList = [];
  int currentPage = 0;
  int balance = 0;
  int expense = 0;
  int income = 0;

  @override
  void initState() {
    loadTransaction();
    super.initState();
  }

  Future<void> loadTransaction() async {
    final data = await DbHelper.getTransactionData(userId: widget.userData.id!);
    setState(() {
      if (data.isNotEmpty) {
        transactionList = data;
        for (int i = 0; i < transactionList.length; i++) {
          if (transactionList[i].type == 0) {
            balance -= transactionList[i].amount;
            expense += transactionList[i].amount;
          } else {
            balance += transactionList[i].amount;
            income += transactionList[i].amount;
          }
        }
      } else {
        transactionList = [];
        balance = 0;
        expense = 0;
        income = 0;
      }
    });
  }

  void changePage(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenList = [
      DashboardScreen(
        transactionList: transactionList,
        balance: balance,
        expense: expense,
        income: income,
        loadTransaction: loadTransaction,
        changePage: changePage,
      ),
      TransactionHistoryScreen(
        transactionList: transactionList,
        loadTransaction: loadTransaction,
      ),
      ProfileScreen(userData: widget.userData),
    ];
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
            changePage(value);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => AddScreen(
                                userId: widget.userData.id!,
                                loadTransaction: loadTransaction,
                              ),
                        ),
                      );
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
