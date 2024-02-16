import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

const USER_COLLECTION = 'users';
const ITEM_COLLECTION = 'items';
const STREAK_COLLECTION = 'streaks';
const PETS_COLLECTION = 'pets';

class DataBase{
  static FirebaseDatabase? firebaseDatabase;
  static DatabaseReference? userCollection;
  static DatabaseReference? itemCollection;
  static DatabaseReference? streakCollection;
  static DatabaseReference? petsCollection;

  static connect() async{
    Platform.isAndroid? await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyABctfAIz0j9N-7a7bIP9KCG38JKBDYvGI',
            appId: '1:60544625479:android:adf1d55fe912ff8263ba62',
            messagingSenderId: '60544625479',
            projectId: 'pawfecttasks',
            databaseURL: 'https://pawfecttasks-default-rtdb.asia-southeast1.firebasedatabase.app'
        )
    ) : await Firebase.initializeApp();
    firebaseDatabase = FirebaseDatabase.instance;
    firebaseDatabase?.setPersistenceEnabled(true);
    firebaseDatabase?.setPersistenceCacheSizeBytes(10000000);
    userCollection = firebaseDatabase?.ref().child(USER_COLLECTION);
    itemCollection = firebaseDatabase?.ref().child(ITEM_COLLECTION);
    streakCollection = firebaseDatabase?.ref().child(STREAK_COLLECTION);
    petsCollection = firebaseDatabase?.ref().child(PETS_COLLECTION);
    if (kDebugMode) {
      firebaseDatabase?.setLoggingEnabled(true);
    }
  }
}