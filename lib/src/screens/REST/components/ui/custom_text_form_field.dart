import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final int errorMaxLines;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final Widget? suffixIcon;
  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.obscureText,
    this.focusNode,
    this.controller,
    this.validator,
    required this.keyboardType,
    this.onFieldSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.suffixIcon,
    required this.errorMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      focusNode: focusNode,
      style: GoogleFonts.poppins(
        fontSize: 15.0,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.poppins(
          fontSize: 15.0,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorMaxLines: errorMaxLines,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
