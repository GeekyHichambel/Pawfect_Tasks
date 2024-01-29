import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:PawfectTasks/Components/AppTheme.dart';

@immutable
class Globals {
  static String sysFont = 'Onset';
  static FlutterSecureStorage prefs = const FlutterSecureStorage();
  static late bool LoggedIN;
  static late String user;

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
        backgroundColor: AppTheme.colors.blissCream,
        textColor: AppTheme.colors.onsetBlue,
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