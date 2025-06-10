import 'package:budget_tracker/screens/main_screen.dart';
import 'package:budget_tracker/screens/register_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static final String id = "/login";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 1.0],
                colors: [AppColor.mainGreen, Color(0xFF00A86B)],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.all(24),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Back",
                      style: AppTextStyles.heading2(
                        fontweight: FontWeight.w900,
                        color: AppColor.mainGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Login to access your account",
                      style: AppTextStyles.body2(
                        fontweight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Username",
                        style: AppTextStyles.body2(
                          fontweight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormFieldWidget(
                      hintText: "Username",
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: AppTextStyles.body2(
                          fontweight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormFieldWidget(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child:
                              isPasswordVisible
                                  ? Icon(
                                    Icons.visibility_outlined,
                                    size: 24,
                                    color: Colors.grey,
                                  )
                                  : Icon(
                                    Icons.visibility_off_outlined,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.mainGreen,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            MainScreen.id,
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Submit",
                          style: AppTextStyles.body1(
                            fontweight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.body2(
                          fontweight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      RegisterScreen.id,
                                    );
                                  },
                            style: AppTextStyles.body2(
                              fontweight: FontWeight.w700,
                              color: AppColor.mainGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
