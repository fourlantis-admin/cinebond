import 'package:flutter/material.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/loading/loading_overlay.dart';

class LoadingWrapper extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final double horizontalPadding;
  final double verticalPadding;

  const LoadingWrapper({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.horizontalPadding = 6,
    this.verticalPadding = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        fit: StackFit.expand,
        children: [
         Center(
              child: Container(color: const Color.fromARGB(255, 15, 15, 15),)
              ),

          /// CONTENT
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: body,
          ),

          /// LOADING OVERLAY
           LoadingOverlay(),
        ],
      ),
    );
  }
}
