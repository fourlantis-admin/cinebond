import 'package:easy_localization/easy_localization.dart';

extension CustomValidators on String {
  String? isEmptyFields() {
    if (isEmpty) {
      return "empty_fields".tr();
    }
    return null;
  }

  String? isValidPassword() {
    if (isEmpty) {
      return "password_is_not_empty".tr();
    }
    if (length < 6) {
      return "password_is_not_valid".tr();
    }
    return null;
  }

  String? isValidEmail() {
    if (isEmpty) {
      return "empty_fields".tr();
    }

    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );

    if (!emailRegex.hasMatch(this)) {
      return "email_format_is_not_valid".tr();
    }

    return null;
  }

String cleanPhoneNumberMask() {
  return this.replaceAll(RegExp(r'\D'), '');
}

  bool isNotEmptyField() {
    return isNotEmpty;
  }
}
