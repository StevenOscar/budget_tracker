import 'package:budget_tracker/screens/add_screen.dart';
import 'package:budget_tracker/screens/login_screen.dart';
import 'package:budget_tracker/screens/main_screen.dart';
import 'package:budget_tracker/screens/register_screen.dart';
import 'package:budget_tracker/screens/transaction_history_screen.dart';
import 'package:budget_tracker/splash_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Budget Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mainGreen),
      ),
      supportedLocales: [Locale('en')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        MainScreen.id: (context) => MainScreen(),
        AddScreen.id: (context) => AddScreen(),
        TransactionHistoryScreen.id: (context) => TransactionHistoryScreen(),
      },
      initialRoute: SplashScreen.id,
    );
  }
}
