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
      create: (_) => SplashCubit()..setTimeoutReached(false),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (prev, state) => state.timeoutReached,
        listener: (context, state) {
          if (state.timeoutReached) {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (_) => LoginView()));
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
