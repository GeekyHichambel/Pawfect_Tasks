import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

const USER_COLLECTION = 'users';
const ITEM_COLLECTION = 'items';
const STREAK_COLLECTION = 'streaks';
const PETS_COLLECTION = 'pets';

class DataBase{
  static var userCollection;
  static var itemCollection;
  static var streakCollection;
  static var petsCollection;

  static connect() async{
    const String connectionUrl = "mongodb+srv://userS:userS@goodcluster.agd8cel.mongodb.net/myApp?retryWrites=true&w=majority";
    var db;
    db = await Db.create(connectionUrl);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    userCollection = db.collection(USER_COLLECTION);
    itemCollection = db.collection(ITEM_COLLECTION);
    streakCollection = db.collection(STREAK_COLLECTION);
    petsCollection = db.collection(PETS_COLLECTION);
    if (kDebugMode) {
      print(status);
      print(await userCollection.find().toList());
      print(await itemCollection.find().toList());
      print(await streakCollection.find().toList());
      print(await petsCollection.find().toList());
    }
  }
}