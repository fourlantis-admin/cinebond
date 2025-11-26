import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isAtlas;
  final bool isDDA;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackButtonPressed;
  final bool showNotifications;
  final int notificationCount;
  final VoidCallback? onSignOutPressed;
  final bool showSignOut;
  final String? title;
  final Color? backgroundColor;

  const CustomAppBar({
    Key? key,
    this.backgroundColor,
    this.isAtlas = false,
    this.isDDA = false,
    this.titleWidget,
    this.showSignOut = true,
    this.showBackButton = true,
    this.onBackButtonPressed,
    this.showNotifications = true,
    this.notificationCount = 0,
    this.onSignOutPressed,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          backgroundColor == null
              ? Theme.of(context).appBarTheme.backgroundColor
              : Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 0,
      actions: null, //_buildActions(),
      title: null, //_buildTitleWidget(context),
      centerTitle: false,
      leading: null,//showBackButton ? _buildBackButton(context) : null,
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
