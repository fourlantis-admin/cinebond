import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final void Function()? onClickBtnFunc;
  final double? btnWidth;
  final double? btnHeight;
  final Color? customColor;
  final bool isButtonDisabled;

  final Widget? trailing;
  final String? trailingImagePath;

  const SecondaryButton({
    super.key,
    required this.title,
    required this.onClickBtnFunc,
    this.btnWidth,
    this.btnHeight,
    this.customColor,
    this.isButtonDisabled = false,
    this.trailing,
    this.trailingImagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: btnWidth ?? double.infinity,
      height: btnHeight ?? 48,
      child: InkWell(
        onTap: isButtonDisabled ? null : onClickBtnFunc,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(2), // BORDER kalınlığı bu
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: isButtonDisabled
                ? null
                : const LinearGradient(
                    colors: [AppColor.MAIN_PURPLE, AppColor.MAIN_BLUE],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColor.WHITE,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (trailing != null || trailingImagePath != null) ...[
                  HorizontalSpacing(10),
                  trailing ??
                      SvgPicture.asset(
                        trailingImagePath!,
                        height: 22,
                        width: 22,
                      ),
                ],
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColor.MAIN_TEXT_COLOR,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
