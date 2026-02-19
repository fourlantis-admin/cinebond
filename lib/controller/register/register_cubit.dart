import 'package:cinebond/models/error/error_resp.dart';
import 'package:cinebond/models/register/register_req.dart';
import 'package:cinebond/utils/storage/store_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cinebond/models/login/login_req.dart';
import 'package:cinebond/service/repositories/google_repository.dart';
import 'package:cinebond/service/repositories/user/user_repository.dart';

class RegisterState {
  final bool isLoading;
  final bool success;
  final ErrorResp? errorResp;

  RegisterState({
    this.isLoading = false,
    this.success = false,
    this.errorResp
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? success,
    ErrorResp? errorResp
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorResp: errorResp ?? this.errorResp,
    );
  }
}


class RegisterCubit extends Cubit<RegisterState> {
  final UserRepository repo;
  final GoogleAuthService googleRepo;
  final StoreManager storeManager;
  RegisterCubit(this.repo,this.googleRepo,this.storeManager) : super(RegisterState());

  void clearError() {
  emit(state.copyWith(errorResp: null));
  }
  
  void fillErrorPopup(String? text){
    emit(state.copyWith(isLoading: false,errorResp: ErrorResp(error: "Hata",error_description: text ?? "Lütfen tekrar deneyiniz.")));
  }

  Future<void> register(RegisterReq req,BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response = await repo.register(context,req);
      print(response);
      await storeManager.saveUser(response);
      emit(state.copyWith(isLoading: false, success: true));
    } catch (e) {
      print(e);
      emit(state.copyWith(isLoading: false,errorResp: ErrorResp(error: "Hata",error_description: e.toString())));
    }
  }
}
