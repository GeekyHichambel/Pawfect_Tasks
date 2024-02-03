import 'package:PawfectTasks/Components/AppTheme.dart';
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
      backgroundColor: AppTheme.colors.gloryBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 0),
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.arrow_back_ios_new_rounded, weight: 30.0,
                    size: 30.0,
                    color: AppTheme.colors.blissCream,)),
                ],
              ),
            )
          ],
        ),
      ),
   );
  }
}