import 'package:PawfectTasks/GLOBALS.dart';
import 'package:flutter/material.dart';
import 'AppTheme.dart';

class CustomAppBar extends StatelessWidget{
  final String name;

  const CustomAppBar({this.name = '',super.key});

  @override
  Widget build(BuildContext context){
    return Padding(padding: const EdgeInsets.only(left: 16.0),
    child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,style: TextStyle(color: AppTheme.colors.friendlyBlack, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
        IconButton(onPressed: (){
      Navigator.of(context).pop();
    }, icon: const Icon(Icons.close_rounded, weight: 30.0,),
    iconSize: 30.0,
    color: AppTheme.colors.blissCream,
    ),]));
  }
}