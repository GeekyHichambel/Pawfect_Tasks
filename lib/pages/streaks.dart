import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';

class Streaks extends StatefulWidget{
  const Streaks({Key? key}) : super(key: key);
  @override
  _StreakState createState() => _StreakState();
}

class _StreakState extends State<Streaks>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 10),
              child: CustomAppBar(),
            )
          ],
        ),
      )
    );
  }

}