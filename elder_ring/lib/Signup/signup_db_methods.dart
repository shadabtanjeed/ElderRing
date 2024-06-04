import 'package:cloud_firestore/cloud_firestore.dart';

class SignupDatabaseMethods {
  Future<void> addUserInfo(Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("user_db")
        .doc(id)
        .set(userInfoMap);
  }
}
