import 'package:flutter/material.dart';

class FormValidationProvider with ChangeNotifier {
  bool _isValid = true;

  bool get isValid => _isValid;

  void validateForm(GlobalKey<FormState> formKey) {
    _isValid = formKey.currentState?.validate() ?? false;
    notifyListeners();
  }
}