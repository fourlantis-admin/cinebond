import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class ProfileDrawer extends StatelessWidget {
  final LoginResp user;
  const ProfileDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final displayName = user.firstName ?? "Kullanıcı";

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: AppColor.DARK_BG,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: AppColor.DARK_BG,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColor.NEON_PURPLE, width: 1),
          ),
          child: Column(
            children: [
              const SizedBox(height:20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.PURPLE_NEON, width: 2),
                ),
              ),
              const SizedBox(height:12),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height:10),
              _buildNotifications(),
              const SizedBox(height:15),
              PrimaryButton(
                title: "View Profile",
                onClickBtnFunc: () {},
                btnWidth: 180,
                btnHeight: 33,
              ),
              const Divider(color: Colors.white12, height: 32),
              _drawerItem(Icons.bookmark_border, "My Lists"),
              _drawerItem(Icons.history, "Watch History"),
              _drawerItem(Icons.group_outlined, "Friends"),
              _drawerItem(
                Icons.logout,
                "Logout",
                onTap: (context) {
                  Navigator.of(context).pop();
                  _signOut(context);
                },
              ),
              const Spacer(),
              // Toggle'lar için StatefulWidget'a taşı ya da Provider kullan
              _drawerToggle("Cinebond Premium", value: false),
              _drawerToggle("TR/EN", value: false),
              const SizedBox(height:20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title,
      {void Function(BuildContext)? onTap}) {
    return Builder(
      builder: (context) => InkWell(
        onTap: onTap != null ? () => onTap(context) : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.85), size: 22),
              const SizedBox(width:20),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.3), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerToggle(String title, {bool value = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style:
                    const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          // Toggle state için StatefulWidget'a çevirmek gerekir,
          // şimdilik gösterim amaçlı:
          Switch(
            value: value,
            onChanged: (_) {},
            activeColor: AppColor.PURPLE_NEON,
          ),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final store = StoreManager();
    await store.removeToken();
    await store.removeUserInfo();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginView()),
      (_) => false,
    );
  }

  Widget _pointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.PURPLE_NEON.withOpacity(0.6),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 15,
            width: 15,
            child: SvgPicture.asset(ImagesIcons.POPCORN_ICON),
          ),
          const SizedBox(width:8),
          Text(
            "350 pts",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.notification_add,
            color: Colors.white.withOpacity(0.85), size: 22),
        const SizedBox(width:25),
        _pointsBadge(),
      ],
    );
  }
}