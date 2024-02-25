import 'package:flutter/material.dart';
import 'AppTheme.dart';

class CustomAppBar extends StatelessWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
        IconButton(onPressed: (){
      Navigator.of(context).pop();
    }, icon: const Icon(Icons.close_rounded, weight: 30.0,),
    iconSize: 30.0,
    color: AppTheme.colors.blissCream,
    ),]);
  }
}