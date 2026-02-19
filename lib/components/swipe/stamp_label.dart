import 'package:flutter/material.dart';

class StampLabel extends StatelessWidget {
   StampLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 3),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 26,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          height: 1.1,
        ),
      ),
    );
  }
}
