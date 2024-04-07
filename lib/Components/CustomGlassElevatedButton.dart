import 'dart:ui';

import 'package:flutter/material.dart';

import 'AppTheme.dart';

class CustomGlassElevatedButton extends StatelessWidget {
  final void Function() onPress;
  final Widget child;

  const CustomGlassElevatedButton({
    super.key,
    required this.onPress,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            width: 100,
            height: 50,
            color: Colors.transparent,
            child: Stack(
              children: [
                BackdropFilter(filter: ImageFilter.blur(
                  sigmaY: 4.0,
                  sigmaX: 4.0,
                ),
                  child: Container(),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border(
                        top: BorderSide(color: AppTheme.colors.darkOnsetBlue.withOpacity(0.53), width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                        left: BorderSide(color: AppTheme.colors.darkOnsetBlue.withOpacity(0.53), width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                        right: BorderSide(color:  AppTheme.colors.darkOnsetBlue.withOpacity(0.53), width: 2.0, strokeAlign: BorderSide.strokeAlignInside),
                        bottom: BorderSide(color:  AppTheme.colors.darkOnsetBlue.withOpacity(0.53), width: 5.0, strokeAlign: BorderSide.strokeAlignInside)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.colors.onsetBlue.withOpacity(0.55),
                          AppTheme.colors.onsetBlue.withOpacity(0.45),
                        ]
                    ),
                  ),
                ),
                Center(child: child,),
              ],
            ),
          ),
        )
    );
  }

}