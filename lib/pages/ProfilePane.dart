import 'package:PawfectTasks/db/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfilePane extends StatefulWidget{
  const ProfilePane({Key? key}) : super(key: key);
  @override
  _ProfilePaneState createState() => _ProfilePaneState();
}

class _ProfilePaneState extends State<ProfilePane>{
  bool imageUp = false;
  bool result = false;
  bool loading = false;

  Future openDialog() => showDialog(
      context: context, builder: (context) => Center(
    child: SizedBox(height: 200,
      child: AlertDialog(
        elevation: 5,
        alignment: Alignment.center,
        contentPadding: const EdgeInsets.all(20.0),
        backgroundColor: AppTheme.colors.friendlyBlack,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Column(
          children: [
            Text('Are you sure you want to Log Out?', style: TextStyle(fontFamily: Globals.sysFont, color: AppTheme.colors.friendlyWhite), textAlign: TextAlign.center,),
            const Expanded(child: SizedBox.shrink()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                loading? CircularProgressIndicator(color: AppTheme.colors.onsetBlue,) :
                ElevatedButton(onPressed: (){
                  setState(() {
                    loading = true;
                  });
                  userLogout().then((_){
                    setState(() {
                      loading = false;
                    });
                    if (result) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                    }
                  });
                }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                    child: const Text('Logout', style: TextStyle(color: Colors.green),)),
                ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
                }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite)),
                    child: const Text('Cancel', style: TextStyle(color: Colors.red),))
              ],
            )
          ],
        ),
      ),
    )
  ).animate(effects: [
    FadeEffect(duration: 200.ms, curve: Curves.fastLinearToSlowEaseIn),
    ScaleEffect(duration: 200.ms, curve: Curves.easeIn)
  ]));

  Future<void> userLogout() async{
    try {
      final User = await DataBase.userCollection?.child(Globals.user).get();
      List tokens = [];
      if (User?.child('fcmTokens').value != null) {
        tokens.addAll(User
            ?.child('fcmTokens')
            .value as List);
        tokens.remove(await DataBase.firebaseMessaging.getToken());
      }
      await DataBase.userCollection?.child(Globals.user).update({
        'fcmTokens' : tokens,
      });
      await Globals.prefs.delete(key: 'loggedIN');
      await Globals.prefs.delete(key: 'user');
      Globals.LoggedIN = false;
      Globals.user = '';
      result = true;
      GlobalVar.globalVar.showToast('Successfully logged out!');
    } catch (e){
      if (kDebugMode) {
        print('Error: $e');
      }
      GlobalVar.globalVar.showToast('Failed to log out!');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10,end: 10,top: 20, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.arrow_back_ios_new_rounded, weight: 30.0,
                      size: 30.0,
                      color: AppTheme.colors.friendlyBlack,)),
                    !Globals.LoggedIN?ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed('/Ulogin');
                    }, style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.onsetBlue),
                    ),
                        child: Text(
                      'Log In',
                      style: TextStyle(
                        color: AppTheme.colors.friendlyWhite
                        ,
                      ),
                    )): ElevatedButton(onPressed: (){
                        setState(() {
                          openDialog();
                        });
                    }, style: ButtonStyle(
                      shape: const MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(side: BorderSide(color: Colors.red))),
                      backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.friendlyWhite),
                    ),
                        child: const Icon( Icons.power_settings_new_rounded,
                          color: Colors.red,
                        )),
                  ],
                ),
              ),
              Expanded(child:
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0,),
                    Center(
                      child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.transparent,
                        shape: CircleBorder(
                          side: BorderSide(color: AppTheme.colors.onsetBlue, width: 2.5),
                        ),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              color: AppTheme.colors.onsetBlue,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(
                                color: Colors.transparent,
                                offset: Offset(0, 0),
                                blurRadius: 30.0,
                              ),
                              ]
                          ),
                          child: Center(
                            child: imageUp? null :
                            Text(Globals.user.isEmpty? 'F' : Globals.user[0],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: Globals.sysFont,
                                fontSize: 80,
                                color: AppTheme.colors.friendlyWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                    const SizedBox(height: 20.0,),
                    Padding(padding: const EdgeInsetsDirectional.all(16.0),
                      child: FadeInAnimation(delay: 1,child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/S>info');
                            },
                            child: CustomBox(color: AppTheme.colors.friendlyBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children:[Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('User Info', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                              const SizedBox(width: 3,),
                                              Icon(CupertinoIcons.profile_circled, color: AppTheme.colors.friendlyWhite, size: 14.0,),
                                            ],
                                          ),
                                          Text('Edit you user profile', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
                                        ],
                                      ),
                                        Align(
                                          child: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyWhite,),
                                        )
                                      ]
                                  )
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/S>kill');
                            },
                            child: CustomBox(color: AppTheme.colors.friendlyBlack,
                                shadow: Colors.transparent,
                                height: 60,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Kill Mode', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                              const SizedBox(width: 3,),
                                              Icon(Icons.dangerous_rounded, color: AppTheme.colors.friendlyWhite, size: 14.0,),
                                            ],
                                          ),
                                          Text('Raise the stakes with kill mode', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
                                        ],
                                      ),
                                      Align(
                                        child: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyWhite,),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/S>notif');
                            },
                            child: CustomBox(color: AppTheme.colors.friendlyBlack,
                                shadow: Colors.transparent,
                                height: 60,
                                child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Notifications', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                                const SizedBox(width: 3,),
                                                Icon(Icons.notifications_active_rounded, color: AppTheme.colors.friendlyWhite, size: 14.0,),
                                              ],
                                            ),
                                            Text('Notification settings', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
                                          ],
                                        ),
                                        Align(
                                          child: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyWhite,),
                                        )
                                      ],
                                    )
                                )),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/S>custom');
                            },child: CustomBox(color: AppTheme.colors.friendlyBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text('Customization', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                              const SizedBox(width: 3,),
                                              Icon(Icons.dashboard_customize_rounded, color: AppTheme.colors.friendlyWhite, size: 14.0,),
                                            ],
                                          ),
                                          Text('Customization settings', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
                                        ],
                                      ),
                                      Align(
                                        child: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyWhite,),
                                      )
                                    ],
                                  )
                              )),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/S>feed');
                            },
                            child: CustomBox(color: AppTheme.colors.friendlyBlack,
                                shadow: Colors.transparent,
                                height: 60,
                                child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Customer Feedback', style: TextStyle(color: AppTheme.colors.friendlyWhite
                                                    , fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                                const SizedBox(width: 3,),
                                                Icon(Icons.feedback_rounded, color: AppTheme.colors.friendlyWhite
                                                  , size: 14.0,),
                                              ],
                                            ),
                                            Text('Give us your valuable feedback', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
                                          ],
                                        ),
                                        Align(
                                          child: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyWhite
                                            ,),
                                        )
                                      ],
                                    )
                                )),
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: (){
                              Navigator.of(context).pushNamed('/S>about');
                            },
                            child: CustomBox(color: AppTheme.colors.friendlyBlack,
                                shadow: Colors.transparent,
                                height: 60,
                                child: Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text('About us', style: TextStyle(color: AppTheme.colors.friendlyWhite
                                                    , fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                                const SizedBox(width: 3,),
                                                Icon(CupertinoIcons.info_circle, color: AppTheme.colors.friendlyWhite
                                                  , size: 14.0,),
                                              ],
                                            ),
                                            Text('Get to know more about us', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
                                          ],
                                        ),
                                        Align(
                                          child: Icon(CupertinoIcons.arrow_right_circle, color: AppTheme.colors.friendlyWhite
                                            ,),
                                        )
                                      ],
                                    )
                                )),
                          )
                        ],
                      ),),
                    ),
                  ],
                ),
              ),
              ),
            ],
          ),
        ),
    );
  }
}