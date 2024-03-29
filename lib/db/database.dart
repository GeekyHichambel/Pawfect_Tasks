import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

const USER_COLLECTION = 'users';
const ITEM_COLLECTION = 'items';
const STREAK_COLLECTION = 'streaks';
const PETS_COLLECTION = 'pets';
const LEADERBOARD_COLLECTION = 'leaderboard';

class DataBase{
  static FirebaseDatabase? firebaseDatabase;
  static DatabaseReference? userCollection;
  static DatabaseReference? itemCollection;
  static DatabaseReference? streakCollection;
  static DatabaseReference? petsCollection;
  static DatabaseReference? leaderboardCollection;
  static Reference? marketStorage;
  static Reference? userPicsStorage;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is for important notifications.',
      importance: Importance.defaultImportance,
      );
  static FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

  static void handleMessage(RemoteMessage? message){
    if (message == null) return;
  }

  static Future initLocalNotifications() async{
    const IOS = DarwinInitializationSettings();
    const Android = AndroidInitializationSettings('@drawable/logo_bg');
    const settings = InitializationSettings(android: Android,iOS: IOS);

    await localNotifications.initialize(
      settings,
    );
    final platform = localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(androidChannel);
  }

  static Future initPushNotifications() async{
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage((_firebaseMessagingBackgroundHandler));
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;
        localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                androidChannel.id,
                androidChannel.name,
                channelDescription: androidChannel.description,
                icon: '@drawable/logo_bg',
              ),
            ),
          payload: jsonEncode(event.toMap()),
        );
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async{
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage){
      if (kDebugMode) {
        print('A new  message received.');
      }
    });
  }

  static Future<void> initNotifications() async{
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final FCMtoken = await firebaseMessaging.getToken(vapidKey: 'BNNtW1LKddzMglciVp8KHQwKTRRKLtwQDMxfUvn01ki4YEzrfzHsGHWbthx-PAWCimqH33r6u6skVVhTNk82grc');
    if (kDebugMode){
      print('Token: $FCMtoken');
    }
    initPushNotifications();
    initLocalNotifications();
  }

  static connect() async{
    kIsWeb? await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC9_jN7Ft-xA6IPPRrzwxyWJbhNRr8k_Kg",
          databaseURL: "https://pawfecttasks-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "pawfecttasks",
          authDomain: 'pawfecttasks.web.app',
          storageBucket: "pawfecttasks.appspot.com",
          messagingSenderId: "60544625479",
          appId: "1:60544625479:web:0f041038fa97004463ba62",
        )
    ) : Platform.isAndroid? await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyABctfAIz0j9N-7a7bIP9KCG38JKBDYvGI',
            appId: '1:60544625479:android:adf1d55fe912ff8263ba62',
            messagingSenderId: '60544625479',
            projectId: 'pawfecttasks',
            authDomain: 'pawfecttasks.firebaseapp.com',
            databaseURL: 'https://pawfecttasks-default-rtdb.asia-southeast1.firebasedatabase.app',
            storageBucket: 'pawfecttasks.appspot.com',
        )
    ) : await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyCrzzrcLyyhhSMuVIxPbSUYajvSI7dUcAw',
          appId: '1:60544625479:ios:5acda2a064e4ae8f63ba62',
          messagingSenderId: '60544625479',
          projectId: 'pawfecttasks',
          authDomain: 'pawfecttasks.firebaseapp.com',
          databaseURL: 'https://pawfecttasks-default-rtdb.asia-southeast1.firebasedatabase.app',
          storageBucket: 'pawfecttasks.appspot.com',
      )
    );
    firebaseDatabase = FirebaseDatabase.instance;
    if (!kIsWeb) {
      firebaseDatabase?.setPersistenceEnabled(true);
      firebaseDatabase?.setPersistenceCacheSizeBytes(10000000);
    }
    userCollection = firebaseDatabase?.ref().child(USER_COLLECTION);
    itemCollection = firebaseDatabase?.ref().child(ITEM_COLLECTION);
    streakCollection = firebaseDatabase?.ref().child(STREAK_COLLECTION);
    petsCollection = firebaseDatabase?.ref().child(PETS_COLLECTION);
    leaderboardCollection = firebaseDatabase?.ref().child(LEADERBOARD_COLLECTION);
    marketStorage = FirebaseStorage.instance.ref().child('pics');
    userPicsStorage = FirebaseStorage.instance.ref().child('users_pics');
    tz.initializeTimeZones();
    if (kDebugMode) {
      firebaseDatabase?.setLoggingEnabled(true);
    }
  }
}