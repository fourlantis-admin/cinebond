import 'package:easy_localization/easy_localization.dart';

extension CustomValidators on String {
  String? isEmptyFields() {
    if (this.isEmpty) {
      return "empty_fields".tr();
    }
  }

  String? isValidPassword() {
    if (this.isEmpty) {
      return "password_is_not_empty".tr();
    }
    if (this.length < 6) {
      return "password_is_not_valid".tr();
    }
  }

  bool isNotEmptyField() {
    return this.isNotEmpty;
  }
}