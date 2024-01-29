import 'package:flutter/material.dart';
import 'package:PawfectTasks/GLOBALS.dart';

class CustomTextField extends StatelessWidget{
  final Color? cursorColor;
  final Color? bgColor;
  final Color? textColor;
  final Color borderColor;
  final String? labelText;
  final Color? labelColor;
  final double? fontSize;
  final bool obscureText;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.cursorColor,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    required this.fontSize,
    required this.obscureText,
    this.suffixIcon,
    this.focusNode,
    this.inputType,
    this.labelText,
    this.labelColor,
    this.controller,
  });

  @override
  Widget build(BuildContext context){
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: bgColor,
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          enableInteractiveSelection: false,
          autocorrect: false,
          focusNode: focusNode,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            labelStyle: TextStyle(
              color: labelColor,
              fontFamily: Globals.sysFont,
              fontSize: fontSize,
            ),
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0,vertical: 16.0),
            labelText: labelText,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
          ),
          cursorColor: cursorColor,
          style: TextStyle(
            color: textColor,
            fontFamily: Globals.sysFont,
            fontSize: fontSize,
          ),
        ),
    );
  }
}