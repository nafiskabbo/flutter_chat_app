import "package:flutter/material.dart";

abstract class Themes {
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff391b69),
      surfaceTint: Color(0xff6b4f9e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5c408d),
      onPrimaryContainer: Color(0xfff5eaff),
      secondary: Color(0xff665780),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe2d0ff),
      onSecondaryContainer: Color(0xff483b62),
      tertiary: Color(0xff381d65),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5b4189),
      onTertiaryContainer: Color(0xfff5eaff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff1d1b20),
      onSurfaceVariant: Color(0xff4a4550),
      outline: Color(0xff7b7581),
      outlineVariant: Color(0xffcbc4d1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffd4bbff),
      primaryFixed: Color(0xffebdcff),
      onPrimaryFixed: Color(0xff260157),
      primaryFixedDim: Color(0xffd4bbff),
      onPrimaryFixedVariant: Color(0xff533784),
      secondaryFixed: Color(0xffebddff),
      onSecondaryFixed: Color(0xff211439),
      secondaryFixedDim: Color(0xffd0bfee),
      onSecondaryFixedVariant: Color(0xff4d4067),
      tertiaryFixed: Color(0xffebdcff),
      onTertiaryFixed: Color(0xff250553),
      tertiaryFixedDim: Color(0xffd4bbff),
      onTertiaryFixedVariant: Color(0xff523881),
      surfaceDim: Color(0xffded8df),
      surfaceBright: Color(0xfffef7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f1f9),
      surfaceContainer: Color(0xfff2ecf3),
      surfaceContainerHigh: Color(0xffede6ee),
      surfaceContainerHighest: Color(0xffe7e0e8),
    );
  }

  static ThemeData light() {
    return theme(lightScheme());
  }

  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              color: states.contains(WidgetState.selected)
                  ? colorScheme.primary
                  : colorScheme.secondary,
              fontWeight:
                  states.contains(WidgetState.selected) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
}
