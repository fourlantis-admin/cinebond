
import 'package:flutter/material.dart';

class VerifiedBadge extends StatelessWidget {
   VerifiedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2979FF),
      ),
      child: Icon(Icons.check, color: Colors.white, size: 16),
    );
  }
}