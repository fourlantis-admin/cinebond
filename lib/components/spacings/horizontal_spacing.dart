import 'package:flutter/material.dart';

class HorizontalSpacing extends StatelessWidget{
  HorizontalSpacing(this.width);

  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.width / 500 * width);
  }
}