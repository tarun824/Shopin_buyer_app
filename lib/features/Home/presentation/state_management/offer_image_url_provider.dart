import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OfferImageUrlProvider with ChangeNotifier {
  List _mainOfferImageUrls = [];

  List get mainOfferImageUrl {
    return [..._mainOfferImageUrls]; //extending existing products
  }

  //will featch products here
  Future<void> fetchImageUrls() async {
    final forId = await FirebaseFirestore.instance.collection('/offers/');
    final broref = await forId.snapshots(); //geting all the docs snapshorts
    await broref.listen((event) async {
      //just listening so that will update on change in database
      event.docs.forEach((element) {
        print(element.data());
      });
      print("came to fetch butttttttt");
      event.docs.forEach((element) async {
        //getting all the docs in single
        print(
            'element is ${element.data()}'); //we get all the field printed here
        final z = await element.data();
        _mainOfferImageUrls.add(z);
        print(_mainOfferImageUrls);
        notifyListeners();
      });
    });
    print("fetch");

    notifyListeners();
  }
}
