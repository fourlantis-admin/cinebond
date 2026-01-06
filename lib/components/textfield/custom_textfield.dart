import 'package:flutter/material.dart';
import 'package:cinebond/utils/theme/app_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cinebond/utils/theme/app_color.dart';

class CustomTextField extends StatefulWidget {
  final Icon? suffixIcon;
  final String? labelText;
  final String? infoText;
  final bool? isInfoText;
  final double? height;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final TextEditingController? textController;
  final bool? isDense;

  final List<TextInputFormatter>? inputFormatters;

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
    this.height,
    this.inputFormatters, 
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
              padding: EdgeInsets.all(isFocused ? 3.5 : 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [AppColor.MAIN_PURPLE, AppColor.MAIN_BLUE],
                ),
              ),
              child: Container(
                height: widget.height ?? 60,
                decoration: BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: TextFormField(
                  controller: widget.textController,
                  keyboardType: widget.inputType,
                  inputFormatters: widget.inputFormatters,
                  style: const TextStyle(
                    color: AppColor.TEXTFIELD_TEXT_COLOR,
                    fontSize: 15,
                  ),
                  validator: (value) {
                    final result = widget.validator?.call(value);
                    setState(() => errorMessage = result);
                    return result;
                  },
                  decoration: InputDecoration(
                    labelText: widget.labelText,
                    labelStyle: const TextStyle(
                      color: AppColor.TEXTFIELD_TEXT_COLOR,
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: AppColor.TEXTFIELD_TEXT_COLOR,
                    ),
                    errorStyle: const TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 0,
                      height: 0,
                    ),
                    border: InputBorder.none,
                    errorText: null,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 18,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: errorMessage == null ? 0 : 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                errorMessage ?? '',
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
