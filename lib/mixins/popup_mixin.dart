import 'package:cinebond/components/popup/generic_popup.dart';
import 'package:flutter/material.dart';

mixin PopupMixin<T extends StatefulWidget> on State<T> {
  void showGenericPopup({
    required String title,
    required String message,
    Widget? icon,
    String? primaryButtonText,
    String? secondaryButtonText,
    Function(String)? onSecondaryButtonPressed,
    Function(String)? onPrimaryButtonPressed,
    bool isSecondaryActive = false,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GenericPopup(
                title: title,
                message: message,
                icon: icon,
                primaryButtonText: primaryButtonText,
                secondaryButtonText: secondaryButtonText,
                isSecondaryActive: isSecondaryActive,
                onPrimaryButtonPressed: onPrimaryButtonPressed,
                onSecondaryButtonPressed: onSecondaryButtonPressed,
              ),
            ),
          ),
        );
      },
    );
  }
}

