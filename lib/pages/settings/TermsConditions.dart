import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget{
  const TermsConditions({Key? key}) : super(key: key);
  @override
  TermsConditionsState createState() => TermsConditionsState();
}

class TermsConditionsState extends State<TermsConditions>{

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 20),
              child: CustomAppBar()
          )
        ],
      ),
    ));
  }
}