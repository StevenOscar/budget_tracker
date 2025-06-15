import 'package:budget_tracker/constants/assets_fonts.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle heading1({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 40,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle heading2({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 30,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle heading3({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 24,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle heading4({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 20,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body1({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 18,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body2({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 14,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }

  static TextStyle body3({required FontWeight fontweight, Color? color, FontStyle? fontStyle, double? fontSize}) {
    return TextStyle(
      fontFamily: AssetsFonts.fontFamilyInter,
      fontSize: fontSize ?? 13,
      fontWeight: fontweight,
      color: color,
      fontStyle: fontStyle,
    );
  }
}
