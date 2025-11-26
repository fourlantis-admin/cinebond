import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cinebond/components/appbar/custom_app_bar.dart';

mixin ViewStateMixin<T extends StatefulWidget> on State<T> {
  buildAppbarWithBackButton(
      {required String title,
      VoidCallback? onExitPressed,
      VoidCallback? onProfilePressed,
      VoidCallback? onBackButtonPressed}) {
    return CustomAppBar(
      title: title,
      showBackButton: true,
      showNotifications: true,
      onBackButtonPressed: onBackButtonPressed,
    );
  }

}
