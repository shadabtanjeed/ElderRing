import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addMedicineInfo(
      Map<String, dynamic> medicineInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("medicine_schedule")
        .doc(id)
        .set(medicineInfoMap);
  }

  Future<Stream<QuerySnapshot>> getMedicineInfo() async {
    return await FirebaseFirestore.instance
        .collection("medicine_schedule")
        .snapshots();
  }

  Future updateMedicineData(String id, Map<String, dynamic> UpdateInfo) async {
    return await FirebaseFirestore.instance
        .collection("medicine_schedule")
        .doc(id)
        .update(UpdateInfo);
  }

  Future deleteMedicineData(String id) async {
    return await FirebaseFirestore.instance
        .collection("medicine_schedule")
        .doc(id)
        .delete();
  }
}
