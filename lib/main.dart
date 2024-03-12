import 'package:PawfectTasks/pages/FriendsPage.dart';
import 'package:PawfectTasks/pages/settings/TermsConditions.dart';
import 'package:PawfectTasks/pages/settings/aboutUs.dart';
import 'package:PawfectTasks/pages/settings/cFeedback.dart';
import 'package:PawfectTasks/pages/settings/killM.dart';
import 'package:PawfectTasks/pages/settings/notif.dart';
import 'package:PawfectTasks/pages/settings/uInfo.dart';
import 'package:PawfectTasks/pages/settings/user_customization.dart';
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
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home' : (context) => const MainPage(),
        '/streaks': (context) => const Streaks(),
        '/Ulogin': (context) => const LoginPage(),
        '/Usignup' : (context) => const SignUpPage(),
        '/Settings' : (context) => const ProfilePane(),
        '/Friends' : (context) => const FriendPage(),
        '/S>about' : (context) => const aboutUs(),
        '/S>terms' : (context) => const TermsConditions(),
        '/S>feed' : (context) => const cFeed(),
        '/S>kill' : (context) => const killM(),
        '/S>notif' : (context) => const notif(),
        '/S>info' : (context) => const Uinfo(),
        '/S>custom' : (context) => const Ucustom(),
      },
    ),
  );
}