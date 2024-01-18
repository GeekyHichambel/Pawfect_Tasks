import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final Color? cursorColor;
  final Color? bgColor;
  final Color? textColor;
  final Color borderColor;
  final String? labelText;
  final Color? labelColor;
  final double? fontSize;
  final TextInputType? inputType;

  const CustomTextField({
    super.key,
    required this.cursorColor,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    required this.fontSize,
    this.inputType,
    this.labelText,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context){
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      color: bgColor,
      child: TextField(
          keyboardType: inputType,
          enableInteractiveSelection: false,
          autocorrect: false,
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: labelColor,
              fontFamily: 'Onset',
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
            fontFamily: 'Onset',
            fontSize: fontSize,
          ),
        ),
    );
  }
}