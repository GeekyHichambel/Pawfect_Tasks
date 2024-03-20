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
  final int? maxLines;
  final bool readOnly;
  final bool enabled;
  final bool canRequestFocus;
  final int? type;

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
    this.maxLines,
    this.type,
    this.canRequestFocus = true,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context){
    return Material(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: bgColor,
      child: TextField(
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          controller: controller,
          keyboardType: inputType,
          enableInteractiveSelection: true,
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
            disabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                borderSide: BorderSide(color: borderColor, width: 1),),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              borderSide: type == Globals.focused?  BorderSide(color: borderColor, width: 1) : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
          ),
          canRequestFocus: canRequestFocus,
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