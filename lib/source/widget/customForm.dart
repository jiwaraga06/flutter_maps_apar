import 'package:flutter/material.dart';
import 'package:flutter_maps_apar/source/widget/color.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint, messageError;
  final bool? obscureText;
  final Widget? prefixIcon, suffixIcon;
  CustomFormField({super.key, this.controller, this.hint, this.obscureText, this.prefixIcon, this.suffixIcon, this.messageError});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText!,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color1, width: 2),
        ),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return messageError;
        }
        return null;
      },
    );
  }
}
