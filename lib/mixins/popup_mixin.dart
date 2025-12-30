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
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
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

