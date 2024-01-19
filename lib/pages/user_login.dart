import 'package:flutter/material.dart';
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
      resizeToAvoidBottomInset: false,
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
                      const SizedBox(width: 20.0,),
                      Image.asset('assets/user_icon.png', width: 45, height: 45,),
                    ],
                  ),
                  const SizedBox(height: 20.0,),
                  /*Expanded(child: */Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16.0)
                    ),
                    child: Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0,vertical: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              inputType: TextInputType.name,
                              fontSize: 16.0,
                              labelText: 'Username',
                              labelColor: AppTheme.colors.onsetBlue,
                              bgColor: AppTheme.colors.blissCream,
                              cursorColor: AppTheme.colors.pleasingWhite,
                              textColor: AppTheme.colors.onsetBlue,
                              borderColor: AppTheme.colors.onsetBlue,
                            ),
                            const SizedBox(height: 20.0,),
                            CustomTextField(
                                labelText: 'Password',
                                inputType: TextInputType.visiblePassword,
                                labelColor: AppTheme.colors.blissCream,
                                cursorColor: AppTheme.colors.pleasingWhite,
                                bgColor: AppTheme.colors.onsetBlue,
                                textColor: AppTheme.colors.blissCream,
                                borderColor: AppTheme.colors.blissCream,
                                fontSize: 16.0),
                            const SizedBox(height: 5,),
                            Padding(padding: const EdgeInsetsDirectional.only(start: 8),
                              child: GestureDetector(
                                onTap: (){

                                },
                                child: Text('Forgot Password',
                                  style: TextStyle(
                                    fontFamily: 'Onset',
                                    color: AppTheme.colors.pleasingWhite,
                                  ),),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  widthFactor: 5,
                                  child: Text('New User?', style: TextStyle(
                                    fontFamily: 'Onset',
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppTheme.colors.blissCream,
                                    color: AppTheme.colors.pleasingWhite,
                                  ),),
                                ),
                                IconButton(onPressed: (){

                                }, style: ButtonStyle(
                                  iconColor: MaterialStatePropertyAll<Color?>(AppTheme.colors.pleasingWhite),
                                  backgroundColor: MaterialStatePropertyAll<Color?>(AppTheme.colors.gloryBlack),
                                ),
                                  icon: const Icon(Icons.login_rounded),),
                              ],
                            ),
                          ],
                        )
                    ),
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