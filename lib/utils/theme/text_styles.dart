import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static TextTheme lightTheme = TextTheme(
    //headline1
    displayLarge: const TextStyle().copyWith(
      color: AppColor.WHITE,
      fontFamily: 'ScienceGothic',
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    )
  );

  static TextTheme darkTheme = TextTheme();
}
