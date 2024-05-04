import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addMedicineInfo(
      Map<String, dynamic> medicineInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("medicine_schedule")
        .doc(id)
        .set(medicineInfoMap);
  }
}