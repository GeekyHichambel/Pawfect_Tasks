import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../Components/AppTheme.dart';

class Ucustom extends StatefulWidget{
  const Ucustom({Key? key}) : super(key: key);
  @override
  UcustomState createState() => UcustomState();
}

class UcustomState extends State<Ucustom>{
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