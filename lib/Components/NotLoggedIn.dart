import 'package:flutter/cupertino.dart';

import '../GLOBALS.dart';
import 'AppTheme.dart';

class NotLoggedInWidget extends StatelessWidget{
  const NotLoggedInWidget({
   super.key
});

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Image.asset('assets/loginFirst.png', height: 200, width: 200, fit: BoxFit.fill,),
        const SizedBox(height: 20,),
        Center(child: Text('Kindly login first to access this section', style: TextStyle(fontWeight: FontWeight.bold,color: AppTheme.colors.friendlyBlack, fontFamily: Globals.sysFont, fontSize: 14),textAlign: TextAlign.center,),),
      ],
    );
  }
}