import 'package:flutter_bloc/flutter_bloc.dart';

class FormValidationCubit extends Cubit<Map<String, String?>> {
  FormValidationCubit()
      : super({
          "email": null,
          "password": null,
        });

  void setFieldError(String field, String? error) {
    emit({...state, field: error});
  }

  bool isValid() {
    // Eğer tüm alanlarda hata yoksa TRUE döner
    return state.values.every((v) => v == null);
  }
}
