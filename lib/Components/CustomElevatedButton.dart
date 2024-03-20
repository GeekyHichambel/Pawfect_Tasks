import 'package:flutter/material.dart';
import 'AppTheme.dart';
import 'CustomBox.dart';

class CustomElevatedButton extends StatelessWidget{
  final void Function() onPress;
  final Widget child;

  const CustomElevatedButton({
    super.key,
    required this.onPress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style:const ButtonStyle(
          padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.zero),
        ),
        child: CustomBox(
          height: 50,
          width: 100,
          border: Border(
              top: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
              left: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
              right: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
              bottom: BorderSide(color: AppTheme.colors.darkOnsetBlue, width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
          shadow: Colors.transparent,
          color: AppTheme.colors.onsetBlue,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: child),
        ),
    );
  }

}