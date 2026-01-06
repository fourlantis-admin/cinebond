import 'package:flutter_bloc/flutter_bloc.dart';

class FormValidationCubit extends Cubit<Map<String, String?>> {
  FormValidationCubit() : super({"email": null, "password": null});

  void setFieldError(String field, String? error) {
    emit({...state, field: error});
  }

  bool isValid() {
    return state.values.every((v) => v == null);
  }
}

class RegisterValidationCubit extends Cubit<Map<String, String?>> {
  RegisterValidationCubit()
    : super({
        "email": null,
        "password": null,
        "re_password": null,
        "phone": null,
      });

  void setFieldError(String field, String? error) {
    emit({...state, field: error});
  }

  bool isValid() {
    return state.values.every((v) => v == null);
  }
}
