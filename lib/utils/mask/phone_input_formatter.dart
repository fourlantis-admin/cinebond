import 'package:flutter/services.dart';
String cleanPhoneNumber(String value) {
  return value.replaceAll(RegExp(r'\D'), '');
}
class PhoneNumberFormatter extends TextInputFormatter {
  static const String prefix = '(+90) ';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // TAMAMEN SİLİNDİYSE
    if (newText.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Prefix'e kadar silindiyse -> boş yap
    if (newText == prefix.trim() || newText == prefix) {
      return const TextEditingValue(text: '');
    }

    // Prefix'i ayıkla
    String raw = newText.startsWith(prefix)
        ? newText.substring(prefix.length)
        : newText;

    // Sadece rakamları al
    String digits = raw.replaceAll(RegExp(r'\D'), '');

    // max 10 hane
    if (digits.length > 10) {
      digits = digits.substring(0, 10);
    }

    // Hiç rakam yoksa boş bırak
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }

    String formatted = prefix;

    if (digits.length <= 3) {
      formatted += digits;
    } else if (digits.length <= 6) {
      formatted += '${digits.substring(0, 3)} ${digits.substring(3)}';
    } else if (digits.length <= 8) {
      formatted +=
          '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6)}';
    } else {
      formatted +=
          '${digits.substring(0, 3)} ${digits.substring(3, 6)} ${digits.substring(6, 8)} ${digits.substring(8)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}