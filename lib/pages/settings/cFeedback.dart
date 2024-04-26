import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../Components/AppTheme.dart';

class cFeed extends StatefulWidget{
  const cFeed({Key? key}) : super(key: key);
  @override
  cFeedState createState() => cFeedState();
}

class cFeedState extends State<cFeed>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(bottom: 20),
              child: CustomAppBar(name: 'Help Center',)
          )
        ],
      ),
    ));
  }
}