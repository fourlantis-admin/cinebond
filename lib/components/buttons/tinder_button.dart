import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class TinderButton extends StatelessWidget {
  final void Function()? onClickBtnFunc;
  final double? btnWidth;
  final double? btnHeight;
  final Color? customColor;
  final Widget? icon;
  final bool isButtonDisabled;
  const TinderButton({
    super.key,
    required this.onClickBtnFunc,
    this.btnWidth,
    this.btnHeight,
    this.customColor,
    this.isButtonDisabled = false,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    
    // Buton rengini belirle, customColor yoksa beyazı kullan
    final buttonColor = customColor ?? AppColor.WHITE;

    return GestureDetector(
      onTap: isButtonDisabled ? null : onClickBtnFunc,
      child: Container(
            height: btnHeight ?? 75,
            width: btnWidth ?? 75,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 8),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  offset: const Offset(0, -3),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: icon,
            ),
          ),
    );
  }
}