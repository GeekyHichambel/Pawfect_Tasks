import 'dart:async';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:PawfectTasks/Components/CustomElevatedButton.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../Components/Animations.dart';
import '../Components/CustomTextField.dart';
import '../GLOBALS.dart';

class ForgotPage extends StatefulWidget{
  const ForgotPage({Key? key}) : super(key: key);
  @override
  ForgotPageState createState() => ForgotPageState();
}

class ForgotPageState extends State<ForgotPage>{
  bool isLoading = false;
  late TextEditingController userNameC = TextEditingController();
  bool isUfocus = false;
  int Stimer = 0;
  final FocusNode UfocusNode = FocusNode();

  Future<bool> SendCode(String Uname) async{
    if (Uname.isEmpty) {GlobalVar.globalVar.showToast('TextField shouldn\'t be left empty'); return false;}
    final user_ref = await DataBase.userCollection?.child(Uname).get();
    if (!user_ref!.exists) {GlobalVar.globalVar.showToast('Couldn\'t find a user with the input name'); return false;}
    if (!user_ref.hasChild('mail')) {
      GlobalVar.globalVar.showToast('Account is not linked to an email address');
      return false;
    }
    String mail_address = user_ref.child('mail').value.toString();
    await DataBase.firebaseAuth.sendPasswordResetEmail(email: mail_address);
    return true;
  }

  void updateTimer(){
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (Stimer == 0) {timer.cancel(); return;}
      setState(() {
        Stimer -= 1;
      });
    });
  }

  @override
  void initState(){
    super.initState();
    UfocusNode.addListener(() {
      setState(() {
        if (UfocusNode.hasFocus){
          isUfocus = true;
        }else{
          isUfocus = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: AppTheme.colors.friendlyWhite,
      resizeToAvoidBottomInset: false,
      body: Column(
          children: [
            const Padding(padding: EdgeInsetsDirectional.symmetric(horizontal: 0.0, vertical: 10.0),
                child: CustomAppBar()
            ),
            Expanded(child: Padding(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Column(
                children: [
                  FadeInAnimation(delay: 1, child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Reset Pass',
                        style: TextStyle(
                          color: AppTheme.colors.friendlyBlack,
                          fontWeight: FontWeight.bold,
                          fontFamily: Globals.sysFont,
                          fontSize: 32.0,
                        ),),
                      const SizedBox(width: 20.0,),
                      Image.asset('assets/user_icon.png', width: 45, height: 45,),
                    ],
                  )),
                  const SizedBox(height: 20.0,),
                  FadeInAnimation(delay: 1.25, child: Container(
                    decoration: BoxDecoration(
                        color: AppTheme.colors.friendlyBlack,
                        borderRadius: BorderRadius.circular(16.0)
                    ),
                    child: Padding(padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0,vertical: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextField(
                              inputType: TextInputType.name,
                              fontSize: 16.0,
                              labelText: !isUfocus? (userNameC.text.isNotEmpty? '' : 'Username') : (''),
                              focusNode: UfocusNode,
                              controller: userNameC,
                              labelColor: AppTheme.colors.onsetBlue,
                              bgColor: AppTheme.colors.friendlyWhite,
                              cursorColor: Colors.grey,
                              textColor: AppTheme.colors.onsetBlue,
                              borderColor: AppTheme.colors.onsetBlue, obscureText: false,
                            ),
                            const SizedBox(height: 20,),
                            Stimer==0? const SizedBox.shrink() :
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Text('Check your mailbox for the password reset link!',textAlign: TextAlign.center ,style: TextStyle(fontFamily: Globals.sysFont, color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500,),),
                            ),
                            isLoading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) :
                            CustomElevatedButton(onPress: (){
                              setState(() {
                                isLoading = true;
                              });
                              if (Stimer == 0) {
                                SendCode(userNameC.text).then((success) {
                                  setState(() {
                                    isLoading = false;
                                    if (success) {
                                      Stimer = 30;
                                      updateTimer();
                                    }
                                  });
                                });
                              }
                            }, child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: Stimer == 0? [
                                Icon(CupertinoIcons.square_arrow_down, color: AppTheme.colors.friendlyWhite, size: 16,),
                                const SizedBox(width: 10.0,),
                                Text('Send', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontSize: 9, fontWeight: FontWeight.w700),),
                              ] : [
                                Text('$Stimer', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite, fontSize: 12, fontWeight: FontWeight.w700),),
                              ],),),
                            const SizedBox(height: 20,),
                            Center(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pushReplacementNamed('/Ulogin');
                                  },
                                  child: Text('< Back to Login', style: TextStyle(
                                    fontFamily: Globals.sysFont,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationThickness: 3.5,
                                    decorationColor: AppTheme.colors.onsetBlue,
                                    color: AppTheme.colors.friendlyWhite,
                                  ),),
                                )
                            ),
                              ],
                        )
                    ),
                  ))
                ],
              ),
            )
            ),
            Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Make sure you have an email address linked to your account so that you can reset your password', textAlign: TextAlign.center, style: TextStyle(
                    fontFamily: Globals.sysFont,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colors.blissCream,
                  ),),
                )
            )
          ],
        ),
    ));
  }

}