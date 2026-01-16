import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class CustomSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CustomSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.all(2), // 🔥 gradient border
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              AppColor.MAIN_PURPLE,
              AppColor.MAIN_BLUE,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 20, 20).withOpacity(0.9),
            ),
            child: TextField(
              onChanged: onChanged, // 🔥 logic DIŞARDAN
              style: const TextStyle(
                color: Color.fromARGB(255, 221, 220, 220),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: "Film ara...",
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 200, 200, 200),
                ),
                prefixIcon: Container(
                  margin: const EdgeInsets.only(left: 12, right: 8),
                  child: const Icon(
                    Icons.search_rounded,
                    color: Colors.white70,
                  ),
                ),
                suffixIcon: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white38,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
