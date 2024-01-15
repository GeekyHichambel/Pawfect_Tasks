import 'package:flutter/material.dart';
import 'package:hit_me_up/Components/AppTheme.dart';
import 'package:hit_me_up/pages/splashScreen.dart';
import 'package:hit_me_up/pages/home.dart';

void main(){
  runApp(
    MaterialApp(
      home: const SplashScreen(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/home' : (context) => const Home(),
      },
    ),
  );
}