import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final StoreManager storeManager = StoreManager();

  final bool isBackButtonActive;
  final bool isPointBadgeActive;
  final bool isAvatarActive;
  final bool isLogoActive;

  final VoidCallback? onBackButtonPressed;

  CustomAppBar({
    super.key,
    this.isBackButtonActive = true,
    this.isPointBadgeActive = true,
    this.isAvatarActive = true,
    this.isLogoActive = true,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: Colors.black,
      title: _buildLeft(context),
      actions: [
        isPointBadgeActive == true ? _pointsBadge() : SizedBox.shrink(),
        HorizontalSpacing(25),
        isAvatarActive == true ? _avatarPlaceholder(context): SizedBox.shrink(),
        HorizontalSpacing(15),

      ],
    );
  }

  // ================= LEFT =================

  Widget _buildLeft(BuildContext context) {
    if (isBackButtonActive) {
      return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBackButtonPressed,
      );
    }

    return const Text(
      "CINEBOND",
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  // ================= POINTS BADGE =================

  Widget _pointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 12, 12, 12).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.PURPLE_NEON.withOpacity(0.6),
          width: 2
        ),
      ),
      child: Row(
        children: [
          Container(
            height:20,width: 20,
            child: SvgPicture.asset(ImagesIcons.POPCORN_ICON)),
          SizedBox(width: 6),
          Text(
            "350 pts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= ICON PLACEHOLDER =================

  Widget _buildSignOutIcon(BuildContext context) {
    return IconButton(
      onPressed: () async {
         print("Exit Icon Tapped");
        await storeManager.removeToken();
        await storeManager.removeUserInfo();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginView()),
          (Route<dynamic> route) => false,
        );
      },
      icon: Icon(Icons.exit_to_app)
    );
  }
  Widget _buildNotificationIcon() {
    return IconButton(
      onPressed: (){
      
      },
      icon: Icon(Icons.notification_add)
    );
  }

  // ================= AVATAR =================

Widget _avatarPlaceholder(BuildContext context) {
  return GestureDetector(
    onTap: (){
      Scaffold.of(context).openEndDrawer();
    },
    child: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColor.PURPLE_NEON.withOpacity(0.25),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.PURPLE_NEON.withOpacity(0.8),
          width: 1.2,
        ),
      ),
      child: const Icon(Icons.person, size: 24, color: Colors.white),
    ),
  );
}


  @override
  Size get preferredSize => const Size.fromHeight(56);
}
