// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:budget_tracker/styles/app_color.dart';
import 'package:budget_tracker/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onEditingComplete;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final int? maxlines;
  final EdgeInsetsGeometry? contentPadding;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.onEditingComplete,
    this.prefixIcon,
    required this.hintText,
    this.contentPadding,
    this.maxlines,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      cursorColor: AppColor.mainGreen,
      maxLines: maxlines ?? 1,
      style: AppTextStyles.body1(fontweight: FontWeight.w500),
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: true,
        hintText: hintText,
        filled: true,
        fillColor: AppColor.mainGreen40,
        hintStyle: AppTextStyles.body1(
          fontweight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
        contentPadding:
            contentPadding ??
            EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
        errorStyle: TextStyle(
          color: Colors.redAccent.shade700,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.black.withAlpha(50), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.redAccent.shade700, width: 2.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.mainGreen, width: 2.5),
        ),
      ),
      validator: validator,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
    );
  }
}
