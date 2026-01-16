import 'dart:ui';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class CustomTitleWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const CustomTitleWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: subtitle == null ? 26 : 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              gradient: LinearGradient(
                colors: [AppColor.MAIN_PURPLE, AppColor.MAIN_BLUE],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          HorizontalSpacing(12),

          /// 🧠 TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  VerticalSpacing(4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (trailing != null) ...[HorizontalSpacing(8), trailing!],
        ],
      ),
    );
  }
}
