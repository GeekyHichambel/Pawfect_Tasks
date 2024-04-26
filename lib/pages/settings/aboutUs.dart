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
    return SafeArea(child: Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.only(bottom: 20),
              child: CustomAppBar(name: 'About Us')
            )
          ],
      ),
    ));
  }
}