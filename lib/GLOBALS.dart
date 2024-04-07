import 'dart:convert';

import 'package:PawfectTasks/db/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif_plus/flutter_gif_plus.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';
import 'package:timezone/timezone.dart';

@immutable
class Globals {
  static String sysFont = 'Poppins';
  static FlutterSecureStorage prefs = const FlutterSecureStorage();
  static late bool LoggedIN;
  static late String user;
  static late List<Map<String,dynamic>> tasks;
  static late List<Map<String,dynamic>> displayTasks;
  static late String profilepicurl;
  static late int currentImage;
  static late bool isprofilepic;
  static const int focused = 1;
  static const int unfocused = 2;

  static Future<void> updatePetStatus() async {
    if (LoggedIN) {
      final data = await DataBase.petsCollection?.child(user).get();
      int initialHunger = data
          ?.child('petStatus/labra/starvation')
          .value as int;
      int hp = data?.child('petStatus/labra/health').value as int;
      if (hp == 0){
        currentImage = 1;
      }else{
        currentImage = 0;
      }
      if (initialHunger == 100) return;
      TZDateTime lastFed = TZDateTime.parse(getLocation('Asia/Kolkata'),data!.child('petStatus/labra/lastFed').value.toString());
      Duration timeDifference = TZDateTime.now(getLocation('Asia/Kolkata')).difference(lastFed);
      int newHunger = (timeDifference.inHours / 1).floor() * 10;
      int lastHunger = data.child('petStatus/labra/lastHunger').value as int;
      newHunger += lastHunger;
      newHunger = newHunger.clamp(0, 100);
      if (initialHunger == newHunger) return;
      if (kDebugMode) {
        print(initialHunger);
        print(newHunger);
      }
      await DataBase.petsCollection?.child(user)
          .child('petStatus/labra')
          .update({
        'starvation': newHunger,
      });
    }
  }

  static Future<void> checkProfilePicUploaded() async{
    if (LoggedIN) {
      Reference? reference = DataBase.userPicsStorage?.child(Globals.user);
      if (reference == null) {
        isprofilepic = false;
      } else {
        isprofilepic = true;
        profilepicurl = await reference.getDownloadURL();
      }
      if (kDebugMode) print('ProfilePic: $isprofilepic');
    }
  }

  static Future<void> lastOnline() async{
    if (LoggedIN) {
      await DataBase.userCollection?.child(user).child('stats').update({
        'last_online' : TZDateTime.now(getLocation('Asia/Kolkata')).toString(),
      });
    }
  }

  Future<void> loadImages(String assetPath, String type, BuildContext context) async{
    try{
      if (type == 'GIF') {
        await fetchGif(AssetImage(assetPath));
      }else{
        await precacheImage(AssetImage(assetPath), context);
      }
      if (kDebugMode) {
        print('Successfully loaded and cached images correctly');
      }
    }catch(e){
      if(kDebugMode){
        print(e);
        print('Failed to load and cache images correctly');
      }
    }
  }

  static updatePref() async{
    if (await prefs.read(key: 'loggedIN') != null) {
      LoggedIN = (await prefs.read(key: 'loggedIN')) == 'true';
    }else{
      LoggedIN = false;
      user = '';
    }
    if (LoggedIN){
      if (await prefs.read(key: 'user') != null){
        user = await prefs.read(key: 'user') as String;
      }
    }
    if (await prefs.read(key: 'tasks') != null){
      final jsonString = await prefs.read(key: 'tasks');
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        if (kDebugMode) print(jsonList);
        final List<Map<String,dynamic>> list = jsonList.map<Map<String,dynamic>>((dynamic map) {
          return Map<String,dynamic>.from(map).map((key,value){
            if (key == 'icon'){
              if (value != null) {
                IconData iconData = IconData(
                    int.parse(value), fontFamily: 'MaterialIcons');
                return MapEntry<String, dynamic>(key, iconData);
              }else{
                return MapEntry<String, dynamic>(key, null);
              }
            }else if (key == 'color') {
              if (value != null) {
                Color color = Color(int.parse(value));
                return MapEntry<String, dynamic>(key, color);
              } else{
                return MapEntry<String, dynamic>(key, null);
              }
            }else {
              return MapEntry<String,dynamic>(key, value);
            }
          });
        }).toList();
        tasks = jsonList.cast<Map<String,dynamic>>();
        displayTasks = list;
      }
    }else{
      tasks = [];
      displayTasks = [];
    }
    if (kDebugMode) {
      print('Logged In: $LoggedIN, User: $user, Tasks: $tasks');
    }
  }

  void showToast(String message) {
    if (!Platform.isWindows) {
      Fluttertoast.showToast(msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 2,
        backgroundColor: AppTheme.colors.onsetBlue,
        textColor: AppTheme.colors.friendlyWhite,
        fontSize: 10.0,
        webBgColor: "#cec7bf",
        webPosition: "center",
      );
    }
  }
}

class GlobalVar {
  static final globalVar = Globals();
}