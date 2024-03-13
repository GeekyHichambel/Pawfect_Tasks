import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget{
  final double height;
  final double? opacity;
  final Widget content;
  final Color? bgColor;
  final Color? borderColor;
  final double? borderWidth;

  const CustomBottomSheet({
    super.key,
    required this.height,
    required this.content,
    this.borderColor,
    this.bgColor,
    this.opacity,
    this.borderWidth,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor?.withOpacity(opacity!),
        border: Border(
          top: BorderSide(
            color: borderColor!,
            width: borderWidth!,
          ),
        )
      ),
      child: content,
    );
  }
}