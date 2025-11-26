import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/main/explore/explore_view.dart';
import 'package:cinebond/view/main/inbox/inbox.view.dart';
import 'package:cinebond/view/main/match/match_view.dart';
import 'package:cinebond/view/main/play/play_view.dart';
import 'dart:ui' as ui;
class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140026),
      extendBody: true,
      body: Container(
        color: AppColor.MAIN_SCAFFOLD_COLOR,
        child: Center(
          child: Text(
            "Explore (Keşfet) İçeriği",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
  
}




