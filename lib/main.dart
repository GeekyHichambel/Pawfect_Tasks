import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/pages/splashScreen.dart';
import 'package:hit_me_up/pages/home.dart';
import 'package:hit_me_up/pages/streaks.dart';
import 'package:hit_me_up/pages/user_login.dart';

void main(){
  runApp(
    MaterialApp(
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home' : (context) => const Home(),
        '/streaks': (context) => const Streaks(),
        '/Ulogin': (context) => const LoginPage(),
      },
    ),
  );
}