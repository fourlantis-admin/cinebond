import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:cinebond/view/main/main_menu_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum SplashRoute {
  login,
  main,
}

class SplashState {
  final bool timeoutReached;
  final SplashRoute? route;

  SplashState({
    this.timeoutReached = false,
    this.route,
  });

  SplashState copyWith({
    bool? timeoutReached,
    SplashRoute? route,
  }) {
    return SplashState(
      timeoutReached: timeoutReached ?? this.timeoutReached,
      route: route ?? this.route,
    );
  }
}


class SplashCubit extends Cubit<SplashState> {
  final StoreManager storeManager;

  SplashCubit(this.storeManager) : super(SplashState());

  Future<void> start() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await storeManager.getToken();
    print(token);
    emit(
      state.copyWith(
        timeoutReached: true,
        route: token == null || token == "" ? SplashRoute.login : SplashRoute.main,
      ),
      
    );
    print(state);
  }
}
