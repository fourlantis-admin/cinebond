import 'dart:ui';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GlassContainer extends StatelessWidget {
  final ImageProvider image;
  final String titleSmall;
  final String titleLarge;
  final String optionLeft;
  final String optionRight;

  const GlassContainer({
    super.key,
    required this.image,
    required this.titleSmall,
    required this.titleLarge,
    required this.optionLeft,
    required this.optionRight,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            /// 🔹 BACKGROUND IMAGE
            Positioned.fill(
              child: Image(image: image, fit: BoxFit.cover),
            ),

            /// 🔹 BLUR + DARK OVERLAY
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.black.withOpacity(0.35)),
              ),
            ),

            /// 🔹 CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLES
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titleSmall,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const VerticalSpacing(4),
                      Text(
                        titleLarge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  /// OPTIONS
                  Row(
                    children: [
                      _OptionChip(text: optionLeft),
                      const SizedBox(width: 8),
                      _OptionChip(
                        text: optionRight,
                        path: ImagesIcons.POPCORN_ICON,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String text;
  final String? path;

  const _OptionChip({required this.text, this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          path != null
              ? Container(
                  width: 15,
                  height: 15,
                  child: SvgPicture.asset(path ?? ""),
                )
              : Container(),
          HorizontalSpacing(2),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
