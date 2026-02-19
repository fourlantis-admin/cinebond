import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/view/main/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cinebond/constants/images-icons/images_icons.dart';
import 'package:cinebond/controller/splash/splash_cubit.dart';
import 'package:cinebond/view/login/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key, required this.title});
  final String title;

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(StoreManager())..start(context),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (prev, curr) => curr.timeoutReached,
        listener: (context, state) {
          if (!state.timeoutReached) return;
          if (state.route == SplashRoute.login) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginView()),
            );
          }
          if (state.route == SplashRoute.main) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const MainMenuView()),
            );
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: Image.asset(
                  ImagesIcons.SPLASH_BG,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Center(
                child: Image.asset(
                  ImagesIcons.LOGO_W_TEXT,
                  fit: BoxFit.fitWidth,
                  width: 500,
                  height: 500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
