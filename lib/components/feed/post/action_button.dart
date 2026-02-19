
// -----------------------------------------------------------------------------
// Action Button
// -----------------------------------------------------------------------------

import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  ActionButton({
    required this.icon,
    required this.count,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? activeColor : Colors.white.withOpacity(0.45);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          VerticalSpacing(4),
          Text(
            _formatCount(count),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return "${(n / 1000).toStringAsFixed(1)}B";
    return n.toString();
  }
}
