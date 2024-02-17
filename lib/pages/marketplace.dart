import 'package:PawfectTasks/GLOBALS.dart';
import 'package:flutter/material.dart';

import '../Components/AppTheme.dart';

class MarketPlace extends StatefulWidget{
  const MarketPlace({Key? key}) : super(key: key);
  @override
  MarketPlaceState createState() => MarketPlaceState();
}

class MarketPlaceState extends State<MarketPlace>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: Globals.LoggedIN? [

          ] : [
            Image.asset('assets/loginFirst.png', height: 200, width: 200, fit: BoxFit.fill,),
            const SizedBox(height: 20,),
            Center(child: Text('Kindly login first to access this section', style: TextStyle(fontWeight: FontWeight.bold,color: AppTheme.colors.pleasingWhite, fontFamily: Globals.sysFont, fontSize: 14)),),
          ],
        ),
      ),
    );
  }
}