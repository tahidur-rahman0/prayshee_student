import 'package:flutter/material.dart';
import 'package:online_training_template/app/const/const.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputAction textInputAction;
  final Function(String)? onChanged;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final int? maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.maxLines,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      onSaved: onSaved,
      obscureText: obscureText,
      textInputAction: textInputAction,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines ?? 1,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: suffixIcon,
              )
            : null,
        border: _outlineInputBorder(),
        enabledBorder: _outlineInputBorder(),
        focusedBorder: _outlineInputBorder(
          borderColor: defaultPrimaryColor,
        ),
        errorBorder: _outlineInputBorder(
          borderColor: Colors.red,
        ),
        focusedErrorBorder: _outlineInputBorder(
          borderColor: Colors.redAccent,
        ),
      ),
    );
  }

  OutlineInputBorder _outlineInputBorder(
      {Color borderColor = const Color(0xFF757575)}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    );
  }
}
