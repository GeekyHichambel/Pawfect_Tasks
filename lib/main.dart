import 'package:PawfectTasks/pages/Calendar.dart';
import 'package:PawfectTasks/pages/FriendsPage.dart';
import 'package:PawfectTasks/pages/settings/aboutUs.dart';
import 'package:PawfectTasks/pages/settings/cFeedback.dart';
import 'package:PawfectTasks/pages/settings/policy.dart';
import 'package:PawfectTasks/pages/settings/storage.dart';
import 'package:PawfectTasks/pages/settings/notif.dart';
import 'package:PawfectTasks/pages/settings/uInfo.dart';
import 'package:PawfectTasks/pages/user_forgot.dart';
import 'package:flutter/material.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:PawfectTasks/pages/ProfilePane.dart';
import 'package:PawfectTasks/pages/splashScreen.dart';
import 'package:PawfectTasks/pages/home.dart';
import 'package:PawfectTasks/pages/streaks.dart';
import 'package:PawfectTasks/pages/user_login.dart';
import 'package:PawfectTasks/pages/user_signup.dart';
import 'db/database.dart';
//TODO: fix repetitive tasks
//TODO: premium feature showcase
//TODO: payment gateways
//TODO: ads
//TODO: server-side tasks
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataBase.connect();
  await DataBase.initNotifications();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home' : (context) => const MainPage(),
        '/calendar' : (context) => const Calendar(),
        '/streaks': (context) => const Streaks(),
        '/Ulogin': (context) => const LoginPage(),
        '/Usignup' : (context) => const SignUpPage(),
        '/Uforgot' : (context) => const ForgotPage(),
        '/Settings' : (context) => const ProfilePane(),
        '/Friends' : (context) => const FriendPage(),
        '/S>about' : (context) => const aboutUs(),
        '/S>feed' : (context) => const cFeed(),
        '/S>kill' : (context) => const killM(),
        '/S>notif' : (context) => const notif(),
        '/S>info' : (context) => const Uinfo(),
        '/S>policy' : (context) => const Policy(),
      },
    ),
  );
}