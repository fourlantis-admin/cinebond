import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class CustomTextField extends StatefulWidget {
  final Icon? suffixIcon;
  final String? labelText;
  final String? infoText;
  final bool? isInfoText;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final TextEditingController? textController;
  final bool? isDense;

  const CustomTextField({
    Key? key,
    this.suffixIcon,
    this.infoText,
    this.labelText,
    this.isInfoText = false,
    this.validator,
    this.inputType = TextInputType.text,
    this.isDense = false,
    this.onTap,
    this.textController,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isFocused = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FocusScope(
          child: Focus(
            onFocusChange: (focus) => setState(() => isFocused = focus),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              padding: EdgeInsets.all(isFocused ? 3.5: 1.8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: const LinearGradient(
                  colors: [AppColor.MAIN_PURPLE, AppColor.MAIN_BLUE],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: TextFormField(
                  controller: widget.textController,
                  keyboardType: widget.inputType,
                  validator: (value) {
                    final result = widget.validator?.call(value);
                    setState(() => errorMessage = result);
                    return result; // validate doğru çalışır
                  },
                  onTap: widget.onTap,
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: const TextStyle(color: AppColor.BLACK),
                    suffixIcon: widget.suffixIcon,
                    border: InputBorder.none,
                    errorText: null,
                    errorStyle: const TextStyle(fontSize: 0, height: 0),
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                  ),
                  style: const TextStyle(color: AppColor.BLACK),
                ),
              ),
            ),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(left: 6, top: 6),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
      ],
    );
  }
}
