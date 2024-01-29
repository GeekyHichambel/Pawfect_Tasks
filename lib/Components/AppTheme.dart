import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/colors.dart';

class AppTheme{
  static const colors = AppColors();
  const AppTheme._();
}
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: AppTheme.colors.gloryBlack,
    primary: AppTheme.colors.pleasingWhite,
    secondary: AppTheme.colors.onsetBlue,
    tertiary: AppTheme.colors.blissCream,
  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: AppTheme.colors.gloryBlack,
    primary: AppTheme.colors.pleasingWhite,
    secondary: AppTheme.colors.onsetBlue,
    tertiary: AppTheme.colors.blissCream,
  )
);