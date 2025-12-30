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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitle(context),
          VerticalSpacing(16), // Space between title and icon
          if (icon != null) ...[
            _buildIcon(),
            VerticalSpacing(16), // Space after the icon
          ],
          _buildMessage(context),
          VerticalSpacing(16),
          _buildPrimaryButton(context, screenHeight),
          VerticalSpacing(16),
          if (isSecondaryActive) ...[
            // Space between primary and secondary button
            _buildSecondaryButton(context, screenHeight),
            VerticalSpacing(16)
          ],
          
        ],
      ),
    );
  }

  // Title Widget
  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  // Message Widget
  Widget _buildMessage(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
    );
  }

  // Icon Widget with Fixed Size
  Widget _buildIcon() {
    return SizedBox(
      width: 37,
      height: 37,
      child: icon!,
    );
  }

  // Primary Button Widget
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

  // Secondary Button Widget
  Widget _buildSecondaryButton(BuildContext context, double screenHeight) {
    return TextButton(onPressed: (){
       if (onSecondaryButtonPressed != null) {
          onSecondaryButtonPressed!(secondaryButtonText ?? "");
        } else {
          Navigator.pop(context);
        }
    }, child: Text(
          secondaryButtonText ?? "",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.light
                  ? AppColor.BLUE
                  : AppColor.BLUE),
        ),);
    
  }
}
