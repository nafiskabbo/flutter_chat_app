import 'package:flutter/services.dart';
import 'package:chat/config/themes/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:chat/core/utils/view_utils.dart';

class DecorationStyles {
  static InputBorder get editTextBorder => const OutlineInputBorder(
        borderSide: BorderSide(color: ThemeColors.darkGray),
      );

  static InputBorder get editTextUnderlineBorder => const UnderlineInputBorder(
        borderSide: BorderSide(color: ThemeColors.darkGray),
      );

  static List<BoxShadow> getBoxShadow(Color color) => [
        BoxShadow(
          color: color.withAlpha(60),
          blurRadius: 16.0,
          spreadRadius: 8.0,
          offset: const Offset(0.0, 16.0),
        ),
      ];

  static SystemUiOverlayStyle appBarSystemUiOverlayStyle({
    BuildContext? context,
    Color? appBarColor,
  }) {
    final statusBarColor = appBarColor ?? context!.primaryColor;
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    );
  }
}
