import 'package:flutter/material.dart';

class GFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool enableSuggestion;
  final bool autocorrect;
  final bool readonly;
  final Widget? suffixIcon;
  final GestureTapCallback? onTap;

  const GFormField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enableSuggestion = true,
    this.autocorrect = true,
    this.suffixIcon,
    this.readonly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
        readOnly: readonly,
        onTap: onTap,
      ),
    );
  }
}
