import 'package:cinebond/view/main/play/theme/game_theme.dart';
import 'package:flutter/material.dart';

class PillBadge extends StatelessWidget {
  final String label;
  final Color color;

  const PillBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(label, style: CineBondTextStyles.label.copyWith(color: color)),
    );
  }
}