import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/main-menu/main_menu_cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

class CustomNavbar extends StatefulWidget {
  final int currentIndex;

  const CustomNavbar({super.key, required this.currentIndex});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  final _keys = List.generate(4, (_) => GlobalKey());
  double _indicatorX = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postFrame();
  }

  @override
  void didUpdateWidget(covariant CustomNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _postFrame();
  }

  void _postFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndicator();
    });
  }

  void _updateIndicator() {
    final key = _keys[widget.currentIndex];
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final parent = context.findRenderObject() as RenderBox?;

    if (box == null || parent == null) return;

    final offset = box.localToGlobal(
      Offset(box.size.width / 2, 0),
      ancestor: parent,
    );

    setState(() => _indicatorX = offset.dx);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 78,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 🔥 INDICATOR (DOĞRU MERKEZ + SOFT MOTION)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.decelerate,
                  top: 5,
                  left: _indicatorX - 34,
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: AppColor.NEON_PURPLE,
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.NEON_PURPLE.withOpacity(0.7),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                  ),
                ),

                /// ICONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(ImagesIcons.EXPLORE_ICON, 0),
                    _navItem(ImagesIcons.HEART_ICON, 1),
                    _navItem(ImagesIcons.INBOX_ICON, 2),
                    _navItem(ImagesIcons.PLAY_ICON, 3),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(String iconPath, int index) {
    final isSelected = widget.currentIndex == index;

    return GestureDetector(
      key: _keys[index],
      onTap: () => context.read<MainMenuCubit>().changeTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeIn,
        transform: Matrix4.translationValues(0, isSelected ? -2 : 0, 0),
        child: SvgPicture.asset(
          iconPath,
          height:isSelected ? 32:29,
          color: isSelected
              ? AppColor.NEON_PURPLE
              : Colors.white.withOpacity(0.45),
        ),
      ),
    );
  }
}
