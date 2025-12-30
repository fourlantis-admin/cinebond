import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/utils/loading/loading_cubit.dart';
import 'package:cinebond/utils/loading/loading_overlay.dart';
import 'package:cinebond/view/main/match/match_view.dart';
import 'package:cinebond/view/wrapper/home_base_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:cinebond/view/main/explore/explore_view.dart';
import 'package:cinebond/view/main/inbox/inbox.view.dart';
import 'package:cinebond/view/main/play/play_view.dart';

class MainMenuView extends StatefulWidget {
  const MainMenuView({super.key});

  @override
  State<MainMenuView> createState() => _MainMenuViewState();
}

class _MainMenuViewState extends State<MainMenuView> {
  int _currentIndex = 0;
  final List<Widget> _views = const [
    ExploreView(),
    MatchView(),
    InboxView(),
    PlayView(),
  ];

  @override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => LoadingCubit(),
    child: HomeBaseView(
      isLoadingActive: true, 
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: _views[_currentIndex],
      ),
      bottomNavigationBar: _buildNavBar(),
    ),
  );
}


  Widget? _buildNavBar() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 8),
      decoration: BoxDecoration(
        color:  Color.fromARGB(255, 169, 163, 171).withOpacity(0.15),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
        boxShadow: [
          BoxShadow(
            color:  Color.fromARGB(255, 36, 36, 36).withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCustomNavItem(ImagesIcons.EXPLORE_ICON, 0, 'Explore'),
            _buildCustomNavItem(ImagesIcons.HEART_ICON, 1, 'Match'),
            _buildCustomNavItem(ImagesIcons.INBOX_ICON, 2, 'Inbox'),
            _buildCustomNavItem(ImagesIcons.PLAY_ICON, 3, 'Play'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNavItem(String iconPath, int index, String label) {
    bool isSelected = _currentIndex == index;
    const Duration animationDuration = Duration(milliseconds: 400);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: animationDuration,
                  child: AnimatedContainer(
                    duration: animationDuration,
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A32C8),
                          Color(0xFF9000C8),
                          Color(0xFFE94057),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9000C8).withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                SvgPicture.asset(iconPath, height: index == 2 ? 25 : 28),
              ],
            ),
            VerticalSpacing(5),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
