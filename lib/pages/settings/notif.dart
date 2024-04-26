import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:flutter/material.dart';

import '../../Components/AppTheme.dart';

class notif extends StatefulWidget{
  const notif({Key? key}) : super(key: key);
  @override
  notifState createState() => notifState();
}

class notifState extends State<notif>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomAppBar(name: 'Notifications'),
      ),
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        ],
      ),
    ));
  }
}