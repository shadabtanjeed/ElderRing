import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/models/locationObj.dart';

class CrudOperations {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createLocation(LocationObj locationObj) async {
    await _db.collection('location_share').doc(locationObj.unique_id).set({
      'position': locationObj.position,
      'unique_id': locationObj.unique_id,
      'updated_on': locationObj.updated_on,
    });
  }

  Future<LocationObj> readLocation(String unique_id) async {
    DocumentSnapshot doc =
        await _db.collection('location_share').doc(unique_id).get();
    return LocationObj(
      position: doc['position'],
      unique_id: doc['unique_id'],
      updated_on: doc['updated_on'].toDate(),
    );
  }

  Future<void> updateLocation(LocationObj locationObj) async {
    await locationObj.updateLocation();
    await _db.collection('location_share').doc(locationObj.unique_id).update({
      'position': locationObj.position,
      'updated_on': locationObj.updated_on,
    });
  }

  Future<void> deleteLocation(String unique_id) async {
    await _db.collection('location_share').doc(unique_id).delete();
  }
}
