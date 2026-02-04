
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';

class MatchPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: AppColor.NEON_PURPLE.withOpacity(0.8),
        ),
        child: const Column(
          children: [
            Text(
              "85% MATCH",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Based on Cinebond Algorithm",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}