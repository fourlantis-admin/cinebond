


import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
   EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border_rounded,
              size: 72, color: Colors.grey.shade300),
          VerticalSpacing( 16),
          Text(
            "Herkesi gördün!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade400,
            ),
          ),
          VerticalSpacing( 8),
          Text(
            "Daha sonra yeni profiller gelecek.",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}