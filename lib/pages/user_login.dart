import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colors.gloryBlack,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          children: [
            Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 0.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).pop();
                  }, icon: Icon(Icons.close,
                    size: 30.0,
                    color: AppTheme.colors.blissCream,
                  )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}