import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';

class ProfilePane extends StatefulWidget{
  const ProfilePane({Key? key}) : super(key: key);
  @override
  _ProfilePaneState createState() => _ProfilePaneState();
}

class _ProfilePaneState extends State<ProfilePane>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppTheme.colors.gloryBlack,
      body: Column(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          )
        ],
      )
    );
  }
}