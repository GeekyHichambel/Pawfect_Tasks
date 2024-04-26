import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../Components/AppTheme.dart';

class killM extends StatefulWidget{
  const killM({Key? key}) : super(key: key);
  @override
  killMState createState() => killMState();
}

class killMState extends State<killM>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 20),
              child: CustomAppBar(name: 'Storage',)
          )
        ],
      ),
    ));
  }
}