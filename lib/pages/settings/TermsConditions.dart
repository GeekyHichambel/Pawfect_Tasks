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