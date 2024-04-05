import 'package:flutter/material.dart';

import '../GLOBALS.dart';

class OutlinedText extends StatelessWidget{
  final String text;
  final double? fontSize;
  final Color? fillColor;
  final Color outlineColor;
  final double strokeWidth;

  const OutlinedText({
    super.key,
    required this.text,
    required this.fillColor,
    required this.outlineColor,
    this.fontSize = 16,
    this.strokeWidth = 2,
});

  @override
  Widget build(BuildContext context){
    return Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: Globals.sysFont,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = strokeWidth
                ..color = outlineColor, // Outline color
            ),
          ),
          Text(text, style: TextStyle(color: fillColor, fontFamily: Globals.sysFont, fontSize: fontSize),
          ),
        ]
    );
  }
}