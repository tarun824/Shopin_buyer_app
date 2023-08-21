import 'package:cloud_firestore/cloud_firestore.dart';

class CreateDbNewUserService {
  Future createUser(userdata) async {
    final docId = userdata["userId"].toString();
    print(userdata["userId"] + "Bole");
    final documentToCreateUser =
        FirebaseFirestore.instance.collection('buyers').doc(userdata["userId"]);
    final uploadJson = {
      "profileurl": "profileurl",
      "userId": userdata["userId"],
      "emailId": userdata["emailId"],
      "name": userdata["name"],
      "phNumber": userdata["phNumber"],
      "address": {
        "sideAddress": userdata["address"]["sideAddress"],
        "city": userdata["address"]["city"],
        "country": userdata["address"]["country"],
        "state": userdata["address"]["state"],
        "pinNumber": userdata["address"]["pinNumber"],
      },
      "isFavorite": [],
      "cart": [],
      "orderHistory": [],
      "coupan": {
        "newToApp": 150,
      },
      "returnProducts": [],
      "groupDetails": {"orderHistory": []},
      "groupsIn": [],
      "coins": 5,
      "status": "new"
    };
    await documentToCreateUser.set(uploadJson);
  }
}
