import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget{
  const CustomSizedBox({
    super.key, 
    required this.height, 
    required this.child,
  });

  final Widget child;
  final double height;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: child,
      height: MediaQuery.of(context).size.height / 100 * height);
  }
  }
  