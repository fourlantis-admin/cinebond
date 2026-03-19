import 'package:flutter/material.dart';

class HorizontalSpacing extends StatelessWidget {
  const HorizontalSpacing(this.width, {super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.width / 1000 * width);
  }
}