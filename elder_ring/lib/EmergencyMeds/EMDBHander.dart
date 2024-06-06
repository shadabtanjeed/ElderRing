import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Emdb {
  final CollectionReference emdbCollection = firestore.collection('emdb');

  Future<bool> addEMSteps(String docName, List<String> steps) async {
    try {
      await emdbCollection.doc(docName).set({
        'title': docName,
        'steps': steps,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getEMSteps(String docName) async {
    try {
      DocumentSnapshot documentSnapshot = await emdbCollection.doc(docName).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data() as Map<String, dynamic>?;
      } else {
        return null;
      }
    } catch (e) {
      print("$e");
      return null;
    }
  }

  Future<List<String>> getEMNames() async {
    try {
      QuerySnapshot querySnapshot = await emdbCollection.get();
      List<String> docNames = querySnapshot.docs.map((doc) => doc.id).toList();
      return docNames;
    } catch (e) {
      print("$e");
      return [];
    }
  }
}
