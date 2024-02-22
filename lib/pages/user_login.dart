import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomTextField.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:PawfectTasks/db/database.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage>{
  final FocusNode UfocusNode = FocusNode();
  final FocusNode PfocusNode = FocusNode();
  late TextEditingController userNameC = TextEditingController();
  late TextEditingController userPasswordC = TextEditingController();
  bool showP = true;
  bool isUfocus = false;
  bool isPfocus = false;
  bool isLoading = false;
  bool result = false;

  Future<void> Userlogin() async{
    try {
      final username = userNameC.text;
      final password = userPasswordC.text;
      if (username.isEmpty || password.isEmpty) {
        GlobalVar.globalVar.showToast('Empty text fields');
        throw Exception('Empty text fields');
      }
      if (password.length < 8){
        GlobalVar.globalVar.showToast('Password is too short');
        throw Exception('Password is too short');
      }
      final user = await DataBase.userCollection?.child(username).get();
      if (user == null || !user.exists){
        GlobalVar.globalVar.showToast('Username is incorrect');
        throw Exception('Username is incorrect');
      }
      final String hashed = user.child('userpass').value.toString();
      if (!BCrypt.checkpw(password, hashed)){
        GlobalVar.globalVar.showToast('Password is incorrect');
        throw Exception('Password is incorrect');
      }
      result = true;
      final fcmToken = await DataBase.firebaseMessaging.getToken();
      final User = await DataBase.userCollection?.child(username).get();
      if (! User!.hasChild('fcmTokens')){
        await DataBase.userCollection?.child(username).update({
          'fcmTokens' : [fcmToken],
        });
      }else {
        List tokens = [];
        tokens.addAll(User.child('fcmTokens').value as List);
        if (tokens.isEmpty) {
          tokens.add(fcmToken);
          await DataBase.userCollection?.child(username).update({
            'fcmTokens': tokens,
          });
        } else if (tokens.contains(fcmToken)) {
          if (kDebugMode) print('Token has already been assigned to the user.');
        } else {
          tokens.add(fcmToken);
          await DataBase.userCollection?.child(username).update({
            'fcmTokens': tokens,
          });
        }
      }
      await Globals.prefs.write(key: 'loggedIN', value: 'true');
      await Globals.prefs.write(key: 'user', value: username);
      Globals.LoggedIN = true;
      Globals.user = username;
      GlobalVar.globalVar.showToast('Successfully logged in!');
    } catch (e){
      if (kDebugMode){
        print('Error: $e');
      }
    }
  }

  @override
  void initState(){
    super.initState();
    UfocusNode.addListener(() {
      setState(() {
        if (UfocusNode.hasFocus) {
          isUfocus = true;
        } else{
          isUfocus = false;
        }
      });
    });
    PfocusNode.addListener(() {
      setState(() {
        if (PfocusNode.hasFocus) {
          isPfocus = true;
        } else{
          isPfocus = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
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
                      Text('Log In',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(height: 20.0,),
                            CustomTextField(
                                labelText: !isPfocus? (userPasswordC.text.isNotEmpty? '' : 'Password') : (''),
                                focusNode: PfocusNode,
                                controller: userPasswordC,
                                inputType: TextInputType.visiblePassword,
                                labelColor: AppTheme.colors.friendlyWhite,
                                cursorColor: AppTheme.colors.pleasingWhite,
                                bgColor: AppTheme.colors.onsetBlue,
                                textColor: AppTheme.colors.friendlyWhite,
                                borderColor: AppTheme.colors.friendlyWhite,
                                suffixIcon: IconButton(
                                  icon: Icon(showP? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () {
                                  setState(() {
                                    showP = !showP;
                                  });
                                },
                                  color: AppTheme.colors.friendlyWhite,
                                ),
                                fontSize: 16.0, obscureText: showP,),
                            const SizedBox(height: 8,),
                            Padding(padding: const EdgeInsetsDirectional.only(start: 8),
                              child: GestureDetector(
                                onTap: (){

                                },
                                child: Text('Forgot Password',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    fontFamily: Globals.sysFont,
                                    color: AppTheme.colors.pleasingWhite,
                                  ),),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Center(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.of(context).pushReplacementNamed('/Usignup');
                                  },
                                  child: Text('New User >', style: TextStyle(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                isLoading? CircularProgressIndicator(color: AppTheme.colors.onsetBlue,) :
                                IconButton(onPressed: (){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Userlogin().then((_){
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (result) {
                                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                                    }
                                  });
                                },hoverColor: AppTheme.colors.lightOnsetBlue,
                                  style: ButtonStyle(
                                    elevation: const MaterialStatePropertyAll<double?>(5.0),
                                    iconColor: MaterialStatePropertyAll<Color?>(AppTheme.colors.onsetBlue),
                                    backgroundColor: MaterialStatePropertyAll<Color?>(AppTheme.colors.friendlyWhite),
                                  ),
                                  icon: const Icon(Icons.login_rounded),)
                              ],
                            ),
                          ],
                        )
                    ),
                  ))
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