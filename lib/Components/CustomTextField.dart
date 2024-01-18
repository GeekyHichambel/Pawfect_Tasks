import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget{
  final Color? cursorColor;
  final Color? bgColor;
  final Color? textColor;
  final Color borderColor;
  final String? labelText;
  final Color? labelColor;

  const CustomTextField({
    super.key,
    required this.cursorColor,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
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
        autocorrect: false,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: labelColor,
            fontFamily: 'Onset',
          ),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: borderColor,
            )
          )
        ),
        cursorColor: cursorColor,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Onset',
        ),
      ),
    );
  }
}