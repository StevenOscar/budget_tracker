import 'package:budget_tracker/constants/assets_images.dart';
import 'package:budget_tracker/models/user_model.dart';
import 'package:budget_tracker/screens/main_screen.dart';
import 'package:budget_tracker/screens/register_screen.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:budget_tracker/utils/preference_helper.dart';
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
  void _login() async {
    int? userId = await DbHelper.authenticateUser(username: usernameController.text, password: passwordController.text);
    if (userId != null) {
      PreferenceHandler.setLogin(true);
      PreferenceHandler.setUserId(userId);
      UserModel? userData = await DbHelper.getUserData(userId: userId);
      if (userData != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(userData: userData)),
          (route) => false,
        );
      } else {
        PreferenceHandler.setLogin(false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.red.shade800, width: 2),
            ),
            content: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  "User data is empty",
                  style: AppTextStyles.body1(fontweight: FontWeight.w500, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.red.shade800, width: 2),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                "User doesn't exist",
                style: AppTextStyles.body1(fontweight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isUsernameValid = false;
  bool isPasswordValid = false;
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
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                margin: const EdgeInsets.all(24),
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AssetsImages.appLogoCropped, width: 140),
                    Text(
                      "Welcome Back",
                      style: AppTextStyles.heading2(fontweight: FontWeight.w900, color: AppColor.mainGreen),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Login to access your account",
                      style: AppTextStyles.body2(fontweight: FontWeight.w400, color: Colors.black),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Username",
                        style: AppTextStyles.body2(fontweight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormFieldWidget(
                      hintText: "Username",
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Username can't be empty";
                        } else if (value.length > 12) {
                          return "Username can't be longer than 12 characte";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty || value.length > 12) {
                            isUsernameValid = false;
                          } else {
                            isUsernameValid = true;
                          }
                        });
                      },
                      controller: usernameController,
                    ),
                    SizedBox(height: isUsernameValid ? 35 : 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: AppTextStyles.body2(fontweight: FontWeight.w500, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormFieldWidget(
                      hintText: "Password",
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value == null || value == "") {
                          isPasswordValid = false;
                          return "Password can't be empty";
                        } else {
                          isPasswordValid = true;
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            isPasswordValid = false;
                          } else {
                            isPasswordValid = true;
                          }
                        });
                      },
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8, top: 4),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child:
                              isPasswordVisible
                                  ? Icon(Icons.visibility_outlined, size: 24, color: Colors.grey)
                                  : Icon(Icons.visibility_off_outlined, size: 24, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: isPasswordValid ? 40 : 17),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.mainGreen,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: isUsernameValid && isPasswordValid ? _login : null,
                        child: Text(
                          "Login",
                          style: AppTextStyles.body1(fontweight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.body2(fontweight: FontWeight.w400, color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    usernameController.clear();
                                    passwordController.clear();
                                    Navigator.pushNamed(context, RegisterScreen.id);
                                  },
                            style: AppTextStyles.body2(fontweight: FontWeight.w700, color: AppColor.mainGreen),
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
