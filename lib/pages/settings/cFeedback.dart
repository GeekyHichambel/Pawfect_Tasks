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