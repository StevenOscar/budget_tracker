import 'package:budget_tracker/models/user_model.dart';
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:budget_tracker/utils/db_helper.dart';
import 'package:budget_tracker/widgets/text_form_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  static final String id = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isNameValid = false;
  bool isUsernameValid = false;
  bool isPasswordValid = false;
  bool isPhoneValid = false;
  bool isPasswordVisible = false;

  void register() async {
    bool isUserDuplicate = await DbHelper.checkUserDataAvailability(
      username: usernameController.text,
    );
    if (isUserDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "User already exist",
                style: AppTextStyles.body1(
                  fontweight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      await DbHelper.insertUserData(
        data: UserModel(
          name: nameController.text,
          username: usernameController.text,
          password: passwordController.text,
          phoneNumber: phoneController.text,
          monthlyBudget: 2000000,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                "User registered successfully",
                style: AppTextStyles.body1(
                  fontweight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

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
                      "Register",
                      style: AppTextStyles.heading2(
                        fontweight: FontWeight.w900,
                        color: AppColor.mainGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Register your account",
                      style: AppTextStyles.body2(
                        fontweight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name",
                        style: AppTextStyles.body2(
                          fontweight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormFieldWidget(
                      hintText: "Name",
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name can't be empty";
                        } else if (RegExp(
                          r'[0-9!@#$%^&*(),.?":{}|<>]',
                        ).hasMatch(value)) {
                          return "Name can't contain number or symbols";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          isNameValid =
                              value.isNotEmpty &&
                              !RegExp(
                                r'[0-9!@#$%^&*(),.?":{}|<>]',
                              ).hasMatch(value);
                        });
                      },
                    ),
                    SizedBox(height: isNameValid ? 35 : 12),
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
                    ),
                    SizedBox(height: isUsernameValid ? 35 : 12),
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
                    SizedBox(height: isPasswordValid ? 35 : 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number",
                        style: AppTextStyles.body2(
                          fontweight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextFormFieldWidget(
                      hintText: "Phone Number",
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]]'),
                        ),
                        FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')),
                      ],
                      validator: (value) {
                        if (value == null || value == "") {
                          isPhoneValid = false;
                          return "Phone Number can't be empty";
                        } else if (RegExp(r'[a-zA-z]').hasMatch(value)) {
                          isPhoneValid = false;
                          return "Phone number can't include alphabet";
                        } else {
                          isPhoneValid = true;
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty ||
                              value.contains(RegExp(r'[a-zA-Z]'))) {
                            isPhoneValid = false;
                          } else {
                            isPhoneValid = true;
                          }
                        });
                      },
                    ),
                    SizedBox(height: isPhoneValid ? 43 : 20),
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
                        onPressed:
                            isNameValid &&
                                    isUsernameValid &&
                                    isPasswordValid &&
                                    isPhoneValid
                                ? register
                                : null,
                        child: Text(
                          "Register",
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
                        text: "Have an account? ",
                        style: AppTextStyles.body2(
                          fontweight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
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
