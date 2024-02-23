import 'package:PawfectTasks/db/database.dart';
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
  static String sysFont = 'Onset';
  static FlutterSecureStorage prefs = const FlutterSecureStorage();
  static late bool LoggedIN;
  static late String user;
  static late bool gifLoaded;

  static Future<void> updatePetStatus() async {
    if (LoggedIN) {
      final data = await DataBase.petsCollection?.child(user).get();
      int initialHunger = data
          ?.child('petStatus/labra/starvation')
          .value as int;
      if (initialHunger == 100) return;
      TZDateTime lastFed = TZDateTime.parse(getLocation('Asia/Kolkata'),data!.child('petStatus/labra/lastFed').value.toString());
      Duration timeDifference = TZDateTime.now(getLocation('Asia/Kolkata')).difference(lastFed);
      int newHunger = (timeDifference.inHours / 1).floor() * 10;
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

  static Future<void> lastOnline() async{
    if (LoggedIN) {
      await DataBase.userCollection?.child(user).child('stats').update({
        'last_online' : TZDateTime.now(getLocation('Asia/Kolkata')).toString(),
      });
    }
  }

  Future<void> loadImages(String assetPath, String type) async{
    try{
      if (type == 'GIF') {
        await fetchGif(AssetImage(assetPath));
        gifLoaded = true;
        if (kDebugMode) {
          print('Successfully loaded and cached images correctly');
        }
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
    if (kDebugMode) {
      print('Logged In: $LoggedIN, User: $user');
    }
  }

  void showToast(String message) {
    if (!Platform.isWindows) {
      Fluttertoast.showToast(msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
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