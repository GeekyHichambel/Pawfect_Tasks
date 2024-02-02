import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/pages/ProfilePane.dart';
import 'package:PawfectTasks/pages/splashScreen.dart';
import 'package:PawfectTasks/pages/home.dart';
import 'package:PawfectTasks/pages/streaks.dart';
import 'package:PawfectTasks/pages/user_login.dart';
import 'package:PawfectTasks/pages/user_signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home' : (context) => const MainPage(),
        '/streaks': (context) => const Streaks(),
        '/Ulogin': (context) => const LoginPage(),
        '/Usignup' : (context) => const SignUpPage(),
        '/Settings' : (context) => const ProfilePane(),
      },
    ),
  );
}