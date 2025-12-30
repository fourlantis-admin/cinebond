import 'package:flutter/material.dart';

class MovieRatingStars extends StatelessWidget {
  final double voteAverage;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const MovieRatingStars({
    super.key,
    required this.voteAverage,
    this.size = 18,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.white24,
  });

  @override
  Widget build(BuildContext context) {
    final rating = (voteAverage / 2).clamp(0, 5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return Icon(Icons.star, color: activeColor, size: size);
        } else if (rating > index && rating < index + 1) {
          return Icon(Icons.star_half, color: activeColor, size: size);
        } else {
          return Icon(Icons.star_border,
              color: inactiveColor, size: size);
        }
      }),
    );
  }
}
