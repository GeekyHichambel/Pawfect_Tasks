import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Components/AppTheme.dart';
import '../../GLOBALS.dart';

class aboutUs extends StatefulWidget{
  const aboutUs({Key? key}) : super(key: key);
  @override
  aboutUsState createState() => aboutUsState();
}

class aboutUsState extends State<aboutUs>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(name: 'About Us'),
      ),
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
      ),
    ));
  }
}