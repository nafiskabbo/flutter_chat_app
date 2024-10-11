import 'package:flutter/material.dart';
import 'package:chat/config/themes/theme_colors.dart';

extension ContextExt on BuildContext {
  // Size
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  double get aspectRatio => MediaQuery.of(this).size.aspectRatio;
  double get longestSide => MediaQuery.of(this).size.longestSide;
  double get shortestSide => MediaQuery.of(this).size.shortestSide;
  Orientation get orientation => MediaQuery.of(this).orientation;
  EdgeInsets get padding => MediaQuery.of(this).padding;

  // Themes
  bool get isDarkMode => MediaQuery.of(this).platformBrightness == Brightness.dark;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get primaryColor => colorScheme.primary;
  Color get onPrimaryColor => colorScheme.onPrimary;
  Color get primaryContainerColor => colorScheme.primaryContainer;
  Color get secondaryColor => colorScheme.secondary;
  Color get onSecondaryColor => colorScheme.onSecondary;
  Color get secondaryContainerColor => colorScheme.secondaryContainer;
  Color get onSecondaryContainerColor => colorScheme.onSecondaryContainer;
  Color get surfaceColor => colorScheme.surface;
  Color get onSurfaceColor => colorScheme.onSurface;
  Color get tertiaryColor => colorScheme.tertiary;
  Color get onTertiaryColor => colorScheme.onTertiary;
  Color get tertiaryContainerColor => colorScheme.tertiaryContainer;
  Color get onTertiaryContainerColor => colorScheme.onTertiaryContainer;
  Color get errorColor => colorScheme.error;
  // Color get dividerColor => lightGray;

  // Snackbar
  void _showSnackBar(String message, {Color? backgroundColor, int durationInSeconds = 3}) {
    if (!mounted) return;
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: durationInSeconds),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showSnackBar(String message, {int durationInSeconds = 3}) {
    _showSnackBar(message, durationInSeconds: durationInSeconds);
  }

  void showSuccessSnackBar(String message, {int durationInSeconds = 3}) {
    _showSnackBar(message,
        backgroundColor: ThemeColors.green, durationInSeconds: durationInSeconds);
  }

  void showErrorSnackBar(String message, {int durationInSeconds = 3}) {
    _showSnackBar(message, backgroundColor: errorColor, durationInSeconds: durationInSeconds);
  }
}

extension WidgetExt on Widget {
  Expanded expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  Padding withPadding(EdgeInsetsGeometry padding) => Padding(padding: padding, child: this);

  SizedBox box({double? width, double? height}) =>
      SizedBox(width: width, height: height, child: this);

  Center center() => Center(child: this);

  Container container(Color color) => Container(color: color, child: this);
}
