import 'package:flutter/material.dart';

class CustomBox extends StatelessWidget{
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final Color shadow;
  final BoxBorder? border;

  const CustomBox({
    super.key,
    required this.child,
    required this.color,
    required this.shadow,
    this.border,
    this.height,
    this.width,
});

  @override
  Widget build(BuildContext context) {
      return Material(
        elevation: 5.0,
        shadowColor: Colors.transparent,
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: border,
            color: color,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
              color: shadow,
              offset: const Offset(0, 0),
              blurRadius: 30.0,
            ),
          ]
          ),
          child: child,
        ),
    );
  }
}