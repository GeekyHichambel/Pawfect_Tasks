import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

const USER_COLLECTION = 'users';

class DataBase{
  static var userCollection;
  static connect() async{
    const String connectionUrl = "mongodb+srv://userS:userS@goodcluster.agd8cel.mongodb.net/myApp?retryWrites=true&w=majority";
    var db;
    db = await Db.create(connectionUrl);
    await db.open();
    inspect(db);
    var status = db.serverStatus();
    userCollection = db.collection(USER_COLLECTION);
    if (kDebugMode) {
      print(status);
      print(await userCollection.find().toList());
    }
  }
}