import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState  extends State<SplashScreen>{
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    navigateToHome(context);
  }

  void navigateToHome(BuildContext context){
    Future.delayed(
      const Duration(seconds: 4),
        (){
          Navigator.pushReplacementNamed(context, '/home');
        }
    );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppTheme.colors.gloryBlack,
        body: Stack(
          children: [
            Image.asset('assets/cardBack.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: AppTheme.colors.blissCream,
            ),
            Center(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: const Color(0xff222222),
                    child: Image.asset('assets/logo.png', fit: BoxFit.cover,)
                ),
              )
            ),
          ],
        )
      );
  }
}