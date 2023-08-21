import 'package:buyer/features/Home/data/data_sources/user_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserDataProvider with ChangeNotifier {
  Map<String, dynamic>? _userData = {};

  void tandaneTane() {
    _userData = {
      "hi": "hello",
    };
    notifyListeners();
  }

  Future FetchUserData(userId) async {
    final forId = await FirebaseFirestore.instance
        .collection('/buyers')
        .where("userId", isEqualTo: userId);
    final broref = await forId.snapshots(); //geting all the docs snapshorts
    final aaaa = await broref.listen((event) async {
      // event.docs.for
      event.docs.forEach((element) async {
        //getting all the docs in single
        print(
            'element is ${element.data()}'); //we get all the field printed here
        final z = await element.data();
        final Map<String, dynamic> ar = await {
          "profileurl": z["profileurl"],
          "userId": z["userId"],
          "name": z["name"],
          "phNumber": z["phNumber"],
          "emailId": z["emailId"],
          "password": z["password"],
          "isFavorite": z["isFavorite"],
          "isFavoriteDetails": z["isFavoriteDetails"],
          "cart": z["cart"],
          "orderHistory": z["orderHistory"],
          "coupan": z["coupan"],
          "returnProducts": z["returnProducts"],
          "coins": z["coins"],
          "status": z["status"]
        };
        print(ar);
        _userData = ar;
        notifyListeners();
      });
    });
    print("fetch");

    notifyListeners();
  }

  Map<String, dynamic>? get userData {
    return _userData;
  }
}
