import 'package:flutter/material.dart';

class MyCustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final Function(String?)? onSaved;

  final String? hint;
  final String? label;
  final String? helper;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool? hide;
  final VoidCallback? callback;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? enabled;
  final Function(String?)? onFieldSubmitted;
  final Function(String?)? onChanged;
  final bool? readOnly;
  final TextInputType textInputType;
  final Function(bool?)? onSuffixIconClick;
  final String? Function(String?)? validator;

  const MyCustomTextField(this.controller, this.textInputType, this.textAlign,
      {Key? key,
      this.focusNode,
      this.enabled,
      this.validator,
      this.helper,
      this.maxLine,
      this.minLine,
      this.maxLength,
      this.hide,
      this.hint,
      this.label,
      this.onSaved,
      this.onFieldSubmitted,
      this.onSuffixIconClick,
      this.prefixIcon,
      this.suffixIcon,
      this.callback,
      this.onChanged,
      this.readOnly})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText: hide == null ? false : hide!,
      onSaved: onSaved,
      enabled: enabled,
      maxLines: maxLine,
      minLines: minLine,
      maxLength: maxLength,
      textAlign: textAlign,
      onFieldSubmitted: onFieldSubmitted,
      onTap: callback,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        contentPadding: const EdgeInsets.all(0.0),
        labelText: label,
        helperText: helper,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        hintText: hint,
      ),
      validator: validator,
      keyboardType: textInputType,
      readOnly: readOnly != null ? readOnly! : false,
    );
  }
}
