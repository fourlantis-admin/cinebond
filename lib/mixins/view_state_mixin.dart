import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cinebond/components/appbar/custom_app_bar.dart';

mixin ViewStateMixin<T extends StatefulWidget> on State<T> {
  buildAppbarWithBackButton(
      {
      bool? isBackButtonActive,
      VoidCallback? onBackButtonPressed,
}) {
    return CustomAppBar(
      isBackButtonActive: true,
      onBackButtonPressed: onBackButtonPressed
    );
  }
buildAppbarWithLogo(
      {
      bool? isBackButtonActive,
}) {
    return CustomAppBar(
      isBackButtonActive: false,
    );
  }

}
