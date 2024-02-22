import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../Components/AppTheme.dart';

class aboutUs extends StatefulWidget{
  const aboutUs({Key? key}) : super(key: key);
  @override
  aboutUsState createState() => aboutUsState();
}

class aboutUsState extends State<aboutUs>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
              child: CustomAppBar()
            )
          ],
        ),
      ),
    );
  }
}