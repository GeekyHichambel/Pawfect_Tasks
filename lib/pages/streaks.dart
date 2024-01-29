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
      backgroundColor: AppTheme.colors.gloryBlack,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: const Icon(Icons.close_rounded, weight: 30.0,),
                    iconSize: 30.0,
                    color: AppTheme.colors.blissCream,
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

}