import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState  extends State<SplashScreen> with SingleTickerProviderStateMixin{
  late AnimationController animationController;

  @override
  void initState(){
    animationController = AnimationController(vsync: this,);
    super.initState();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed){
        navigateToHome(context);
      }
    });
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }


  void navigateToHome(BuildContext context){
          Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppTheme.colors.onsetBlue,
        body: Lottie.asset('assets/splashScreen.json',
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
            ),
      );
  }
}