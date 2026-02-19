import 'package:cinebond/service/repositories/user/user_repository.dart';
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

  Future<void> start(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    final token = await storeManager.getToken();
    
    UserRepository repo = UserRepository();
    final user = await storeManager.getUser();
    print(user);
    print(token);
    if(user?.id != null)
     {
      try {
        final profile = await repo.getUserProfile(context,user?.id ?? "");
        
      } catch (e) {
        print(e);
      }
     } 

    emit(
      state.copyWith(
        timeoutReached: true,
        route: token == null || token == "" ? SplashRoute.login : SplashRoute.main,
      ),
      
    );
    print(state);
  }
}
