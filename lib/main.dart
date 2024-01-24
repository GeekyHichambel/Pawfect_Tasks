import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/GLOBALS.dart';
import 'package:hit_me_up/pages/splashScreen.dart';
import 'package:hit_me_up/pages/home.dart';
import 'package:hit_me_up/pages/streaks.dart';
import 'package:hit_me_up/pages/user_login.dart';
import 'package:hit_me_up/pages/user_signup.dart';
import 'package:hit_me_up/db/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBase.connect();
  await Globals.updatePref();
  runApp(
    MaterialApp(
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home' : (context) => const Home(),
        '/streaks': (context) => const Streaks(),
        '/Ulogin': (context) => const LoginPage(),
        '/Usignup' : (context) => const SignUpPage(),
      },
    ),
  );
}