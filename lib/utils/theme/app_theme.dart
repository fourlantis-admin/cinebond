import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'ScienceGothic',
    colorScheme: ColorScheme.light(
      primary:  AppColor.MAIN_BLUE,
      secondary:  AppColor.MAIN_PURPLE,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color.fromARGB(255, 24, 24, 24),
    fontFamily: 'ScienceGothic',
    colorScheme: ColorScheme.dark(
      primary: AppColor.MAIN_BLUE,
      secondary: AppColor.MAIN_PURPLE,
    ),
  );
}