import 'package:flutter_bloc/flutter_bloc.dart';

class SplashState {
  final bool timeoutReached;

  SplashState({
    this.timeoutReached = false,
  });
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState());

  void setTimeoutReached(bool reached) {
    Future.delayed(Duration(seconds: 2), () {}).then((_) {
      emit(SplashState(timeoutReached: true));
    });
  }
}
