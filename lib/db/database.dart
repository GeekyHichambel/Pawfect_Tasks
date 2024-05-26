import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  static Reference? marketFoodStorage;
  static Reference? marketPetStorage;
  static Reference? userPicsStorage;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static AndroidNotificationChannel androidChannel = const AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'This channel is for important notifications.',
      );
  static AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      androidChannel.id,
      androidChannel.name,
      channelDescription: androidChannel.description,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'logo_bg',
      styleInformation: const BigTextStyleInformation(''),
    );
  static FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();

  static void handleMessage(RemoteMessage? message){
    if (message == null) return;
  }

  static Future initLocalNotifications() async{
    const IOS = DarwinInitializationSettings();
    const Android = AndroidInitializationSettings('logo_bg');
    const settings = InitializationSettings(android: Android,iOS: IOS);
    localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
    await localNotifications.initialize(
        settings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  static void onNotificationTap(NotificationResponse notificationResponse) {

  }

  static notificationDetails() {
    return NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails());
  }

  static Future schedule({int id = 0,String? title,String? body,String? payload, required DateTime scheduledTime}) async{
    return localNotifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        await notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
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
            notificationDetails(),
          payload: jsonEncode(event.toMap()),
        );
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage remoteMessage) async{
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage){
      if (kDebugMode) {
        print('A new message received.');
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
    marketFoodStorage = FirebaseStorage.instance.ref().child('pics');
    marketPetStorage = FirebaseStorage.instance.ref().child('pet_pics');
    userPicsStorage = FirebaseStorage.instance.ref().child('users_pics');
    tz.initializeTimeZones();
    String currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));
    if (kDebugMode) {
      firebaseDatabase?.setLoggingEnabled(true);
    }
  }
}