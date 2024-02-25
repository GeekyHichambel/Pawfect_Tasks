import 'package:PawfectTasks/Components/CustomAppBar.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/db/database.dart';
import 'package:timezone/timezone.dart';
import '../Components/AppTheme.dart';
import '../Components/CustomTextField.dart';
import '../GLOBALS.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage>{
  late String userName;
  late String userPassword;
  late String userCPassword;
  late TextEditingController userNameC = TextEditingController();
  late TextEditingController userPasswordC = TextEditingController();
  late TextEditingController userCPasswordC = TextEditingController();
  final FocusNode UfocusNode = FocusNode();
  final FocusNode PfocusNode = FocusNode();
  final FocusNode CPfocusNode = FocusNode();
  bool showP = true;
  bool showCP = true;
  bool isUfocus = false;
  bool isPfocus = false;
  bool isCPfocus = false;
  bool isLoading = false;
  bool result = false;

  Future<void> NewUser() async{
    try {
      userName = userNameC.text;
      userPassword = userPasswordC.text;
      userCPassword = userCPasswordC.text;
      if (userName.isEmpty || userPassword.isEmpty || userCPassword.isEmpty){
        GlobalVar.globalVar.showToast('Empty text fields');
        throw Exception('Empty text fields');
      }
      if (userCPassword != userPassword){
        GlobalVar.globalVar.showToast('Password doesn\'t match');
        throw Exception('Password doesn\'t match');
      }
      if (!isValidUsername(userName)){
        GlobalVar.globalVar.showToast('Username can only contain alphabets and numbers');
        throw Exception('Username can only contain alphabets and numbers');
      }
      if (userPassword.length < 8){
        GlobalVar.globalVar.showToast('Password is too short');
        throw Exception('Password is too short');
      }
      if (!isValidPassword(userPassword)){
        GlobalVar.globalVar.showToast('Password can only contain alphabets, numbers and special characters');
        throw Exception('Password can only contain alphabets, numbers and special characters');
      }
      final snapshot = await DataBase.userCollection?.child(userName).get();
      if (snapshot!.exists){
        GlobalVar.globalVar.showToast('User already exists');
        throw Exception('User already exists');
      }
      final TimeStamp = TZDateTime.now(getLocation('Asia/Kolkata'));
      final List<String> pets = ['labra'];
      final Map<String, dynamic> petParams = {'mood' : 'Happy',
        'health' : 100,
        'starvation' : 0,
        'lastFed' : TimeStamp.toString(),
        'nickname' : 'Labra',
      };
      final Map<String, Map<String, dynamic>> petStatus = {'labra' : petParams};
      final List<String> decoitems = [];
      const int streak = 0;
      const int pawCoin = 50;
      const int xp = 0;
      const int petFood = 0;
      final String hashed = BCrypt.hashpw(userPassword, BCrypt.gensalt());
      final Map<String, dynamic> userDoc = {
        'userpass' : hashed,
      };
      final Map<String, dynamic> petsDoc = {
        'pets' : pets,
        'petStatus' : petStatus,
      };
      final Map<String, dynamic> streakDoc = {
        'streak' : streak,
        'xp' : xp,
      };
      final Map<String, dynamic> itemsDoc = {
        'pawCoin' : pawCoin,
        'petFood' : petFood,
        'decoitems' : decoitems,
      };
      await DataBase.userCollection?.child(userName).set(userDoc);
      await DataBase.streakCollection?.child(userName).set(streakDoc);
      await DataBase.petsCollection?.child(userName).set(petsDoc);
      await DataBase.itemCollection?.child(userName).set(itemsDoc);
      result = true;
      GlobalVar.globalVar.showToast('Successfully Signed Up');
    }catch(e){
      if (kDebugMode){
        print('Error: $e');
      }
    }
  }

  bool isValidUsername(String username){
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]+$');
    return regExp.hasMatch(username);
  }

  bool isValidPassword(String userPassword){
    RegExp regExp = RegExp(r'^[a-zA-Z0-9!@#\$&_?-]+$');
    return regExp.hasMatch(userPassword);
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

    CPfocusNode.addListener(() {
      setState(() {
        if (CPfocusNode.hasFocus) {
          isCPfocus = true;
        }else{
          isCPfocus = false;
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
              child: CustomAppBar(),
            ),
            Expanded(child: Padding(
              padding: const EdgeInsetsDirectional.all(16.0),
              child: Column(
                children: [
                  FadeInAnimation(delay: 1, child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Sign Up',
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
                              controller: userNameC,
                              focusNode: UfocusNode,
                              labelColor: AppTheme.colors.onsetBlue,
                              bgColor: AppTheme.colors.friendlyWhite,
                              cursorColor: Colors.grey,
                              textColor: AppTheme.colors.onsetBlue,
                              borderColor: AppTheme.colors.onsetBlue, obscureText: false,
                            ),
                            const SizedBox(height: 20.0,),
                            CustomTextField(
                                labelText: !isPfocus? (userPasswordC.text.isNotEmpty? '' : 'Password') : (''),
                                controller: userPasswordC,
                                focusNode: PfocusNode,
                                inputType: TextInputType.visiblePassword,
                                labelColor: AppTheme.colors.friendlyWhite,
                                cursorColor: AppTheme.colors.pleasingWhite,
                                bgColor: AppTheme.colors.onsetBlue,
                                textColor: AppTheme.colors.friendlyWhite,
                                borderColor: AppTheme.colors.friendlyWhite,
                                fontSize: 16.0, obscureText: showP,
                                suffixIcon: IconButton(
                                  icon: Icon(showP? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () {
                                    setState(() {
                                      showP = !showP;
                                    });
                                },
                                  color: AppTheme.colors.friendlyWhite,
                                ),
                            ),
                            const SizedBox(height: 20,),
                            CustomTextField(
                              inputType: TextInputType.name,
                              fontSize: 16.0,
                              labelText: !isCPfocus? (userCPasswordC.text.isNotEmpty? '' : 'Confirm Password') : (''),
                              controller: userCPasswordC,
                              focusNode: CPfocusNode,
                              labelColor: AppTheme.colors.onsetBlue,
                              bgColor: AppTheme.colors.friendlyWhite,
                              cursorColor: Colors.grey,
                              textColor: AppTheme.colors.onsetBlue,
                              borderColor: AppTheme.colors.onsetBlue, obscureText: showCP,
                              suffixIcon: IconButton(
                                icon: Icon(showCP? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () {
                                  setState(() {
                                    showCP = !showCP;
                                  });
                              },
                                color: AppTheme.colors.onsetBlue,
                              ),
                            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                isLoading? CircularProgressIndicator(color: AppTheme.colors.onsetBlue,) :
                                IconButton(onPressed: (){
                                  setState(() {
                                    isLoading = true;
                                  });
                                  NewUser().then((_){
                                    setState(() {
                                      isLoading = false;
                                    });
                                    if (result){Navigator.of(context).pushReplacementNamed('/Ulogin');}
                                  });
                                },hoverColor: AppTheme.colors.darkOnsetBlue,
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
                  )),
                ],
              ),
            )
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'By Signing up you agree to our ',
                        style: TextStyle(color: AppTheme.colors.blissCream, fontSize: 24),
                        children: [
                          TextSpan(text: 'Terms ', style: const TextStyle(fontWeight: FontWeight.w700), recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.of(context).pushNamed('/S>terms');
                          }),
                          const TextSpan(text: 'and '),
                          TextSpan(text: 'Conditions', style: const TextStyle(fontWeight: FontWeight.w700), recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.of(context).pushNamed('/S>terms');
                          }),
                        ]
                    )
                ),
              )
            )
          ],
        ),
      ),
    );
  }

}