import 'package:buyer/domain/entities/user_entities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataServices {
  Future<Map<String, dynamic>?> userDataServices(userId) async {
    print("userDataServices");

    // final y = ['glass', 'pot'];
    // final x = ['plastic', 'rubber'];
    // final bro = ['indoor', 'outdoors'];

    // final String homeKitchen = "/buyers/";

    // final url = '/idea_1_products/mobile and accessories/accessories';
    // final reference = FirebaseFirestore.instance.collection(homeKitchen).doc(). ;
    // await reference.get();
    // final snapshots = reference.snapshots();
    // print("This issssssssssssssssssssss what you get");
    // final Map<String, Map<String, Map<String, dynamic>>> dumy = {
    //   'para': {
    //     "color": {
    //       "red": {"price": 150, 'qty': 5},
    //       "green": {"price": 299, 'qty': 90},
    //     },
    //     "size": {
    //       "xl": {"price": 550, 'qty': 15},
    //       "green": {"price": 99, 'qty': 9},
    //     },
    //   }
    // };
    // final lohData1 = {
    //   'para': {
    //     "color": {
    //       "red": {"price": 50, 'qty': 105},
    //       "green": {"price": 199, 'qty': 200},
    //     },
    //     "size": {
    //       "xl": {"price": 500, 'qty': 15},
    //       "green": {"price": 69, 'qty': 109},
    //     },
    //   }
    // };
    // final lohData2 = {
    //   'para': {
    //     "color": {
    //       "red": {"price": 20, 'qty': 10},
    //       "green": {"price": 499, 'qty': 16},
    //     },
    //   }
    // };
    // final lohData3 = {'para': {}};
    // reference.doc("outdoors").collection("pot").add(
    //       lohData2,
    //     );
    // final z = reference
    //     // .where("fieldName", isEqualTo: soft)
    //     .where(
    //       "thismap",
    //     )
    //     .limit(2);
    // await z.get();
    // print("Count is $z");
    // final a = reference
    //     // .where("fieldName", isEqualTo: soft)
    //     .where("thismap", arrayContains: "soft")
    //     .limit(2);
    // await a.get();
    // print(snapshots.listen((event) {
    //   print("event $event");
    // }));
    // List<UserEntities> decodedData = [];
    // final arrId = [];
    Map<String, dynamic> ar = {};
    // final forId = await FirebaseFirestore.instance
    //     .collection('/buyers')
    //     .where("userId", isEqualTo: userId);
    // // QuerySnapshot querySnapshot = await forId.get();
    // final broref = await forId.snapshots(); //geting all the docs snapshorts
    // await broref.listen((event) async {
    //   //just listening so that will update on change in database
    //   // event.docs.for
    //   event.docs.forEach((element) async {
    //     //getting all the docs in single
    //     print(
    //         'element is ${element.data()}'); //we get all the field printed here
    //     final z = await element.data();
    //     final Map<String, dynamic> ar = await {
    //       "profileurl": z["profileurl"],
    //       "userId": z["userId"],
    //       "name": z["name"],
    //       "phNumber": z["phNumber"],
    //       "emailId": z["emailId"],
    //       "password": z["password"],
    //       "isFavorite": z["isFavorite"],
    //       "isFavoriteDetails": z["isFavoriteDetails"],
    //       "cart": z["cart"],
    //       "orderHistory": z["orderHistory"],
    //       "coupan": z["coupan"],
    //       "returnProducts": z["returnProducts"],
    //       "coins": z["coins"],
    //       "status": z["status"]
    //     };
    //     // decodedData.add(ar);
    //     print(ar);
    //     // element.data().forEach((key, value) {
    //     // print("hayo went iside");
    //     // here we are intarating through all the map inside field
    //     // if (key == 'para') {
    //     //just ckecking if the key is para
    //     // ar.add(value); //add the value of the para key to ar
    //     // final bro = forId.where('para.color');

    //     // if (!arrId.contains(element.id)) {
    //     // weather cheaking that if that elemengt id that means
    //     //document id is present if not then only add because if we donot add this check then
    //     //every time iteraion or reload this ar array goes on building
    //     //     arrId.add(element.id);
    //     //   }
    //     // } else {
    //     //   print("$key is $value");
    //     // }
    //     // });
    //   });
    //   // print('ar is $ar');
    // });
    final forId = await FirebaseFirestore.instance
        .collection('/buyers')
        .where("userId", isEqualTo: userId);
    // QuerySnapshot querySnapshot = await forId.get();
    final broref = await forId.snapshots(); //geting all the docs snapshorts
    final aaaa = await broref.listen((event) {
      //just listening so that will update on change in database
      // event.docs.for
      event.docs.forEach((element) {
        //getting all the docs in single
        print(
            'element is ${element.data()}'); //we get all the field printed here
        final z = element.data();
        final Map<String, dynamic> ar = {
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
        // decodedData.add(ar);
        print(ar);

        // element.data().forEach((key, value) {
        // print("hayo went iside");
        // here we are intarating through all the map inside field
        // if (key == 'para') {
        //just ckecking if the key is para
        // ar.add(value); //add the value of the para key to ar
        // final bro = forId.where('para.color');

        // if (!arrId.contains(element.id)) {
        // weather cheaking that if that elemengt id that means
        //document id is present if not then only add because if we donot add this check then
        //every time iteraion or reload this ar array goes on building
        //     arrId.add(element.id);
        //   }
        // } else {
        //   print("$key is $value");
        // }
        // });
      });
      // print('ar is $ar');
    });
    // querySnapshot.docs.forEach((doc) {
    //   Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;
    //   print('documne is $documentData');
    //   decodedData.add(documentData);
    // });
    // print("decodedData is $decodedData");

    // await snapshots.listen((snapshot) {
    //   print("snapshots $snapshots");
    //   print("snapshot $snapshot");
    //   print("reference $reference ");
    //   int count = 0;
    //   print(reference.get());
    //   snapshot.docs.forEach((snapshot) {
    //     print(snapshot.data());
    //   });
    // snapshot.docs.forEach((snapshot) => snapshot.data().forEach((key, value) {
    //       count++;
    //       print('$key is $value');
    //       print(snapshot.data());
    //       if ((key.contains("mobile and laptops"))) {
    //         print(snapshot.data());
    //       }
    //     }
    //     ));
    // print(arrId);
    // }
    // );s
    // if () {
    //   return null;
    // }
    // if (ar != {}) {
    //   return ar;
    // }
    return ar == {} ? null : ar;
  }
}
