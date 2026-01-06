import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/main-menu/main_menu_cubit.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CustomNavbar extends StatelessWidget {
  final int currentIndex;

  const CustomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        color:  Color.fromARGB(255, 169, 163, 171).withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color:  Color.fromARGB(255, 36, 36, 36).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(context, ImagesIcons.EXPLORE_ICON, 0, 'Explore'),
            _navItem(context, ImagesIcons.HEART_ICON, 1, 'Match'),
            _navItem(context, ImagesIcons.INBOX_ICON, 2, 'Inbox'),
            _navItem(context, ImagesIcons.PLAY_ICON, 3, 'Play'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    String iconPath,
    int index,
    String label,
  ) {
    final isSelected = currentIndex == index;
    const animationDuration = Duration(milliseconds: 600);

    return GestureDetector(
      onTap: () => context.read<MainMenuCubit>().changeTab(index),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isSelected ? 1 : 0,
                  duration: animationDuration,
                  child: AnimatedContainer(
                    duration: animationDuration,
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A32C8),
                          Color(0xFF9000C8),
                          Color(0xFFE94057),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9000C8).withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(child: SvgPicture.asset(iconPath, height: isSelected == true ? 40 : 34,color: AppColor.WHITE,)),
              ],
            ),
            // Text(
            //   label,
            //   style: TextStyle(
            //     color: isSelected ? Colors.white : Colors.white70,
            //     fontSize: 12,
            //     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
