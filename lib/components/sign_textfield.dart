import 'package:flutter/material.dart';

class SignTextfield extends StatelessWidget {
  final TextEditingController controller;
  
  final String hintText;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errMessage;
  final String? Function(String?)? onChanged;

  const SignTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.keyboardType,
      this.suffixIcon,
      this.onTap,
      this.prefixIcon,
      this.validator,
      this.focusNode,
      this.errMessage,
      this.onChanged,
       required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.blue,
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onTap: onTap,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      
      decoration: InputDecoration(
        floatingLabelStyle: const TextStyle(color:Colors.blue),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey,width: 1)
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red,width: 2)
        ),
        focusedErrorBorder: const OutlineInputBorder(
           borderSide: BorderSide(color: Colors.red,width: 2)
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue,width: 2)
        ),
         floatingLabelBehavior: FloatingLabelBehavior.auto,
        hintText: hintText,
        labelText: labelText,
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: const TextStyle(color: Colors.grey ,),
        hintStyle: const TextStyle(color: Colors.grey)
      ),
    );
  }
}
