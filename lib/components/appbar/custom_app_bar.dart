import 'package:cinebond/components/spacings/horizontal_spacing.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/view/login/login_view.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {


  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 55,
      backgroundColor: Colors.black,
      elevation: 0,
      title: Image.asset(ImagesIcons.LOGO, height: 55),
      actions: [
        GestureDetector(
          onTap: () => print("Leaderboard Icon Tapped"),
          child: Image.asset(ImagesIcons.LEADERBOARD_ICON, height: 45),
        ),
        HorizontalSpacing(16),
        GestureDetector(
          onTap: () {
            print("Exit Icon Tapped");
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginView()),
              (Route<dynamic> route) => false,
            );
          },
          child: Image.asset(ImagesIcons.EXIT_ICON, height: 55),
        ),
      ],
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
