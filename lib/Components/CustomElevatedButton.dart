import 'package:flutter/material.dart';
import 'AppTheme.dart';
import 'CustomBox.dart';

class CustomElevatedButton extends StatelessWidget{
  final void Function() onPress;
  final Widget child;
  final double height;
  final double width;
  final Color? outlineColor;
  final Color? fillColor;

  CustomElevatedButton({
    super.key,
    required this.onPress,
    required this.child,
    this.height = 50,
    this.width = 100,
    this.outlineColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style:const ButtonStyle(
          padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
        ),
        child: CustomBox(
          height: height,
          width: width,
          border: Border(
              top: BorderSide(color: outlineColor ?? AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
              left: BorderSide(color: outlineColor ?? AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
              right: BorderSide(color:  outlineColor ?? AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
              bottom: BorderSide(color:  outlineColor ?? AppTheme.colors.darkOnsetBlue, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
          shadow: Colors.transparent,
          color: fillColor ?? AppTheme.colors.onsetBlue,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: child),
        ),
    );
  }
}