import 'package:budget_tracker/screens/login_screen.dart';
import 'package:budget_tracker/screens/register_screen.dart';
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
      },
      initialRoute: SplashScreen.id,
    );
  }
}
