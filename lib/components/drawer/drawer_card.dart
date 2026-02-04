import 'package:cinebond/components/buttons/primary_button.dart';
import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/components/spacings/vertical_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/models/login/login_resp.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/utils/theme/app_color.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileDrawer extends StatelessWidget {
  LoginResp user;
  ProfileDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.78,
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 12, top: 12, bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              VerticalSpacing(20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.PURPLE_NEON, width: 2),
                ),
              ),

              VerticalSpacing(12),

              Text(
                user.firstName.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              VerticalSpacing(10),
              _buildNotifications(),

              VerticalSpacing(15),
              PrimaryButton(
                title: "View Profile",
                onClickBtnFunc: () {},
                btnWidth: 180,
                btnHeight: 33,
              ),

              Divider(color: Colors.white12, height: 32),
              _drawerItem(Icons.bookmark_border, "My Lists"),
              _drawerItem(Icons.history, "Watch History"),
              _drawerItem(Icons.group_outlined, "Friends"),
              _drawerItem(
                Icons.logout,
                "Logout",
                onTap: () {
                  Navigator.of(context).pop();
                  _signOut(context);
                },
              ),

              Spacer(),
              _drawerToggle(value: false, "Cinebond Premium"),
              _drawerToggle(value: false, "TR/EN"),

              VerticalSpacing(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.85), size: 22),
            HorizontalSpacing(20),
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
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.3),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerToggle(
    String title, {
    bool value = false,
    ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: (value) {
              value = !value;
            },
            activeColor: AppColor.PURPLE_NEON,
          ),
        ],
      ),
    );
  }

  _signOut(BuildContext context) async {
    StoreManager storeManager = StoreManager();
    print("Exit Icon Tapped");
    await storeManager.removeToken();
    await storeManager.removeUserInfo();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginView()),
      (Route<dynamic> route) => false,
    );
  }

  Widget _pointsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 12, 12, 12).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.PURPLE_NEON.withOpacity(0.6),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 15,
            width: 15,
            child: SvgPicture.asset(ImagesIcons.POPCORN_ICON),
          ),
          VerticalSpacing(8),
          Text(
            "350 pts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _buildNotifications() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notification_add,
          color: Colors.white.withOpacity(0.85),
          size: 22,
        ),
        HorizontalSpacing(25),
        _pointsBadge(),
      ],
    );
  }
}
