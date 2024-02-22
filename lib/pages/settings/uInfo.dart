import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class Uinfo extends StatefulWidget{
  const Uinfo({Key? key}) : super(key: key);
  @override
  UinfoState createState() => UinfoState();
}

class UinfoState extends State<Uinfo>{

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