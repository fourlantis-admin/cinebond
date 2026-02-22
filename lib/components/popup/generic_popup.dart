import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';

class GenericPopup extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final Function(String)? onSecondaryButtonPressed;
  final Function(String)? onPrimaryButtonPressed;
  final bool isSecondaryActive;

  const GenericPopup({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    required this.primaryButtonText,
    this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.isSecondaryActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.MAIN_BLUE,
              AppColor.MAIN_PURPLE,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(5.5), // BORDER THICKNESS
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // BACKGROUND
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTitle(context),
              const VerticalSpacing(16),
              if (icon != null) ...[
                _buildIcon(),
                const VerticalSpacing(16),
              ],
              _buildMessage(context),
              const VerticalSpacing(20),
              _buildPrimaryButton(context, screenHeight),
              const VerticalSpacing(16),
              if (isSecondaryActive) ...[
                _buildSecondaryButton(context, screenHeight),
                const VerticalSpacing(8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(color: Colors.black),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontSize: 16, color: Colors.black87),
    );
  }

  Widget _buildIcon() {
    return SizedBox(
      width: 40,
      height: 40,
      child: icon!,
    );
  }

  Widget _buildPrimaryButton(BuildContext context, double screenHeight) {
    return PrimaryButton(
      btnHeight: screenHeight * 0.06,
      title: primaryButtonText ?? "",
      onClickBtnFunc: () {
        if (onPrimaryButtonPressed != null) {
          onPrimaryButtonPressed!(primaryButtonText ?? "");
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _buildSecondaryButton(BuildContext context, double screenHeight) {
    return TextButton(
      onPressed: () {
        if (onSecondaryButtonPressed != null) {
          onSecondaryButtonPressed!(secondaryButtonText ?? "");
        } else {
          Navigator.pop(context);
        }
      },
      child: Text(
        secondaryButtonText ?? "",
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColor.BLUE,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
