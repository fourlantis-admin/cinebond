import 'package:cinebond/models/error/error_resp.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinebond/models/login/login_req.dart';
import 'package:cinebond/service/repositories/google_repository.dart';
import 'package:cinebond/service/repositories/login/login_repository.dart';

class LoginState {
  final bool isLoading;
  final bool success;
  final ErrorResp? errorResp;

  LoginState({
    this.isLoading = false,
    this.success = false,
    this.errorResp
  });

  LoginState copyWith({
    bool? isLoading,
    bool? success,
    ErrorResp? errorResp
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorResp: errorResp ?? this.errorResp,
    );
  }
}


class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repo;
  final GoogleAuthService googleRepo;
  final StoreManager storeManager;
  LoginCubit(this.repo,this.googleRepo,this.storeManager) : super(LoginState());

  void clearError() {
  emit(state.copyWith(errorResp: null));
  }

  Future<void> authenticate(LoginReq req,BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await repo.login(context,req);
      print(response);
      await storeManager.saveUser(response);
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      print(e.toString());
      emit(state.copyWith(isLoading: false,errorResp: ErrorResp(error: "Hata",error_description: e.toString())));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await googleRepo.signInWithGoogle();
      print(response);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
    finally {
      emit(state.copyWith(isLoading: false));
    }
  }
}
