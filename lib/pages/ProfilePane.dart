import 'package:PawfectTasks/db/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/Animations.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/Components/CustomBox.dart';
import 'package:PawfectTasks/GLOBALS.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePane extends StatefulWidget{
  const ProfilePane({Key? key}) : super(key: key);
  @override
  _ProfilePaneState createState() => _ProfilePaneState();
}

class _ProfilePaneState extends State<ProfilePane>{
  bool result = false;
  bool loading = false;

  Future openDialog() => showDialog(
      context: context, builder: (context) => Center(
    child: SizedBox(height: 200,
      child: AlertDialog(
        elevation: 0,
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
                loading? SpinKitThreeBounce(color: AppTheme.colors.onsetBlue,) :
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
        tokens.remove(await DataBase.firebaseMessaging.getToken(vapidKey: 'BNNtW1LKddzMglciVp8KHQwKTRRKLtwQDMxfUvn01ki4YEzrfzHsGHWbthx-PAWCimqH33r6u6skVVhTNk82grc'));
      }
      await DataBase.userCollection?.child(Globals.user).update({
        'fcmTokens' : tokens,
      });
      await Globals.prefs.delete(key: 'loggedIN');
      await Globals.prefs.delete(key: 'user');
      Globals.LoggedIN = false;
      Globals.user = '';
      Globals.profilepicurl = '';
      Globals.isprofilepic = false;
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
    return SafeArea(child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.colors.friendlyWhite,
      body: Padding(
          padding: const EdgeInsetsDirectional.only(start: 10,end: 10,top: 0, bottom: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 0.0),
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          }, icon: Icon(Icons.arrow_back_ios_new_rounded, weight: 30.0,
                        size: 30.0,
                        color: AppTheme.colors.blissCream,)),
                      !Globals.LoggedIN?ElevatedButton(onPressed: (){
                        Navigator.of(context).pushNamed('/Ulogin');
                      }, style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.onsetBlue),
                      ),
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              color: AppTheme.colors.friendlyWhite,
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
                ),
              Expanded(child:
              SingleChildScrollView(
                physics: const RangeMaintainingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 30.0,),
                    Center(
                      child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.colors.friendlyBlack, width: 2.0),
                              color: Globals.LoggedIN? Globals.isprofilepic? AppTheme.colors.friendlyWhite : AppTheme.colors.onsetBlue : AppTheme.colors.onsetBlue,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(
                                color: Colors.transparent,
                                offset: Offset(0, 0),
                                blurRadius: 30.0,
                              ),
                              ]
                          ),
                          child: Globals.LoggedIN? Globals.isprofilepic? ClipOval(
                            child: Image.network(Globals.profilepicurl, fit: BoxFit.cover, loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent? event){
                              if (event == null){
                                return child;
                              }else {
                                return SpinKitThreeBounce(
                                  color: AppTheme.colors.onsetBlue,
                                );
                              }
                            },),
                          ): Center(
                            child: Text(Globals.user.isEmpty? 'F' : Globals.user[0],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: Globals.sysFont,
                                fontSize: 80,
                                color: AppTheme.colors.friendlyWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ) : Center(
                            child: Text(Globals.user.isEmpty? 'F' : Globals.user[0],
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
                      ),
                    const SizedBox(height: 20.0,),
                        !Globals.isPremium? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: (){

                            },
                            child: Stack(
                                alignment: AlignmentDirectional.centerStart,
                                fit: StackFit.passthrough,
                                children: [
                                 Container(
                                      height: 150,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppTheme.colors.blissCream),
                                        borderRadius: BorderRadius.circular(16.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 5,),
                                                  Text('Try Premium Now!', style: TextStyle(
                                                    fontFamily: Globals.sysFont,
                                                    fontSize: 16,
                                                    color: AppTheme.colors.friendlyBlack,
                                                    fontWeight: FontWeight.bold,
                                                  ),),
                                                  const SizedBox(height: 10,),
                                                  Text('No Ads, exclusive features, and much more.', style: TextStyle(
                                                    fontFamily: Globals.sysFont,
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Image.asset('assets/premium_logo.png'),
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                  ),
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                    child: Image.asset('assets/premium.png', height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ) : const SizedBox.shrink(),
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
                                              Text('Storage', style: TextStyle(color: AppTheme.colors.friendlyWhite, fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                              const SizedBox(width: 3,),
                                              Icon(Icons.storage_rounded, color: AppTheme.colors.friendlyWhite, size: 14.0,),
                                            ],
                                          ),
                                          Text('Manage the app data', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
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
                                                Text('Help Center', style: TextStyle(color: AppTheme.colors.friendlyWhite
                                                    , fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: Globals.sysFont),),
                                                const SizedBox(width: 3,),
                                                Icon(Icons.feedback_rounded, color: AppTheme.colors.friendlyWhite
                                                  , size: 14.0,),
                                              ],
                                            ),
                                            Text('Receive help from the teams', style: TextStyle(color: AppTheme.colors.pleasingWhite, fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: Globals.sysFont),),
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
                                                Text('About', style: TextStyle(color: AppTheme.colors.friendlyWhite
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
    ));
  }
}