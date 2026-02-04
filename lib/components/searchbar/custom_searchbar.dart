import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'dart:ui';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CustomSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColor.WHITE.withOpacity(1),
              blurRadius: 1,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: AppColor.NEON_PURPLE.withOpacity(1),
              blurRadius: 3,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: AppColor.NEON_PURPLE.withOpacity(1),
              blurRadius: 3,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.DARK_CARD.withOpacity(0.85),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColor.NEON_PURPLE.withOpacity(0.6),
                  width: 1.2,
                ),
              ),
              child: TextField(
                onChanged: onChanged, // ✅ LOGIC AYNI
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Film ara...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(1)),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColor.WHITE,
                    size: 30,
                  ),

                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
