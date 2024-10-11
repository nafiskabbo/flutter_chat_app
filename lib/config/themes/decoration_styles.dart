import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:chat/core/utils/view_utils.dart';

class DecorationStyles {
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
