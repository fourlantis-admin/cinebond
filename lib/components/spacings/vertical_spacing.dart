import 'package:flutter/material.dart';

class VerticalSpacing extends StatelessWidget{
  VerticalSpacing(this.height);

  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height / 1000 * height);
  }
  }
  