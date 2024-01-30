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
        backgroundColor: AppTheme.colors.complimentaryBlack,
        shadowColor: AppTheme.colors.blissCream,
        shape: const RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(16.0))),
        content: Column(
          children: [
            Text('Are you sure you want to Log Out?', style: TextStyle(fontFamily: Globals.sysFont),),
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
                }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.gloryBlack)),
                    child: const Text('Logout', style: TextStyle(color: Colors.green),)),
                ElevatedButton(onPressed: (){
                    Navigator.of(context).pop();
                }, style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.gloryBlack)),
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
      backgroundColor: AppTheme.colors.gloryBlack,
      body: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0, vertical: 20.0),
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
                      color: AppTheme.colors.blissCream,)),
                    !Globals.LoggedIN?ElevatedButton(onPressed: (){
                      Navigator.of(context).pushNamed('/Ulogin');
                    }, style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.onsetBlue),
                    ),
                        child: Text(
                      'Log In',
                      style: TextStyle(
                        color: AppTheme.colors.blissCream,
                      ),
                    )): ElevatedButton(onPressed: (){
                        setState(() {
                          openDialog();
                        });
                    }, style: ButtonStyle(
                      shape: const MaterialStatePropertyAll<OutlinedBorder>(CircleBorder(side: BorderSide(color: Colors.red))),
                      backgroundColor: MaterialStatePropertyAll<Color>(AppTheme.colors.gloryBlack),
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
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                              color: AppTheme.colors.complimentaryBlack,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(
                                color: AppTheme.colors.blissCream,
                                offset: const Offset(0, 0),
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
                                color: AppTheme.colors.blissCream,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )),
                    const SizedBox(height: 10.0,),
                    Padding(padding: const EdgeInsetsDirectional.all(16.0),
                      child: FadeInAnimation(delay: 1,child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
                          const SizedBox(height: 16.0),
                          CustomBox(color: AppTheme.colors.complimentaryBlack,
                              shadow: Colors.transparent,
                              height: 60,
                              child: const Row(
                                children: [

                                ],
                              )),
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