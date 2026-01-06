import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final StoreManager storeManager = StoreManager();
  final bool isBackButtonActive;
  final bool isLeaderboardIconActive;
  final bool isExitIconActive;
  final VoidCallback? onBackButtonPressed;

  CustomAppBar({
    Key? key,
    this.isBackButtonActive = false,
    this.isLeaderboardIconActive = false,
    this.isExitIconActive = false,
    this.onBackButtonPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 55,
      backgroundColor: Colors.black,
      elevation: 0,
      title: _buildTitle(isBackButtonActive),
      actions: [
        _buildLeaderBoardIcon(context),
        HorizontalSpacing(16),
        _buildExitIcon(context),
      ],
    );
  }

  _buildLeaderBoardIcon(BuildContext context) {
    return GestureDetector(
      onTap: () => print("Leaderboard Icon Tapped"),
      child: Image.asset(ImagesIcons.LEADERBOARD_ICON, height: 45),
    );
  }

  _buildExitIcon(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("Exit Icon Tapped");
        await storeManager.removeToken();
        await storeManager.removeUserInfo();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginView()),
          (Route<dynamic> route) => false,
        );
      },
      child: Image.asset(ImagesIcons.EXIT_ICON, height: 55),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget? _buildTitle(bool isBackButtonActive) {
    return isBackButtonActive
        ? IconButton(
            icon: Icon(Icons.arrow_back, size: 30),
            onPressed: onBackButtonPressed,
          )
        : Image.asset(ImagesIcons.LOGO, height: 55);
  }
}
