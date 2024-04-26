import 'dart:async';

import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import '../GLOBALS.dart';
import '../db/database.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState  extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late VideoPlayerController videoPlayerController;
  bool load = true;
  bool animationCompleted = false;
  final GlobalKey<ScaffoldState> Skey = GlobalKey<ScaffoldState>();


  @override
  void initState(){
    animationController = AnimationController(vsync: this,);
    super.initState();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        setState(() {
          load = false;
        });
        loadConfigs().then((_){
          Future.delayed(const Duration(milliseconds: 200),(){
            navigateToHome(context);
          });
        });
      }
    });
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

  Future<void> loadConfigs() async{
    await DataBase.connect();
    await DataBase.initNotifications();
    await Globals.updatePref();
    await Globals.checkPremium();
    await Globals.updatePetStatus();
    await Globals.lastOnline();
    await Globals.checkProfilePicUploaded();
  }

  void navigateToHome(BuildContext context) {
          Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
      GlobalVar.globalVar.loadImages('assets/fect tasks.png', 'Image', context);
      return Scaffold(
        backgroundColor: AppTheme.colors.friendlyWhite,
        body: load? Lottie.asset('assets/splashScreen.json',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              controller: animationController,
              onLoaded: (composition){
                animationController
                  ..duration = composition.duration
                  ..forward();
              },
              frameRate: FrameRate.composition,
              backgroundLoading: true,
              repeat: false,
              animate: load,
            ): SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            key: Skey,
            body: Padding(
              padding: const EdgeInsetsDirectional.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage('assets/fect tasks.png')),
                  LinearProgressIndicator(color: AppTheme.colors.onsetBlue, borderRadius: BorderRadius.circular(10), backgroundColor: AppTheme.colors.friendlyBlack,),
                  const SizedBox(height: 20,),
                  Center(child: Text('Onboarding now, please hang on tightly', style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: Globals.sysFont),textAlign: TextAlign.center,),)
                ],
              ),
            )
          ),
        ),
      );
  }
}