import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/Components/CustomTextField.dart';

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
            ),
            Expanded(child: Padding(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Log In',
                        style: TextStyle(
                          color: AppTheme.colors.pleasingWhite,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Onset',
                          fontSize: 32.0,
                        ),),
                      const SizedBox(width: 30.0,),
                      Image.asset('assets/user_icon.png', width: 45, height: 45,),
                    ],
                  ),
                  Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0,vertical: 32.0),
                    child: Column(
                      children: [
                        CustomTextField(
                          labelText: 'UserName',
                          labelColor: AppTheme.colors.pleasingWhite,
                          bgColor: AppTheme.colors.complimentaryBlack,
                          cursorColor: AppTheme.colors.onsetBlue,
                          textColor: AppTheme.colors.pleasingWhite,
                          borderColor: AppTheme.colors.onsetBlue,
                        ),
                      ],
                    )
                  )
                ],
              ),
            )
            ),
          ],
        ),
      ),
    );
  }

}