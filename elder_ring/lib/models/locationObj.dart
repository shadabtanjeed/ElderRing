import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationObj {
  GeoPoint position;
  final String unique_id;
  DateTime updated_on;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Location location = Location();

  static const int LOCATION_UPDATE_LIMIT = 10;

  LocationObj(
      {required this.position,
      required this.unique_id,
      required this.updated_on});

  Future<void> update() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentLocation = await location.getLocation();

    position = GeoPoint(currentLocation.latitude!, currentLocation.longitude!);
    updated_on = DateTime.now();

    _db.collection('location_db').doc(unique_id).set({
      'position': position,
      'unique_id': unique_id,
      'updated_on': updated_on,
    });
  }

  static Future<bool> exists(String uniqueId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc =
        await db.collection('location_db').doc(uniqueId).get();
    return doc.exists;
  }

  bool isLocationUpToDate(DateTime updatedOn) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(updatedOn);
    return difference.inMinutes <= LOCATION_UPDATE_LIMIT;
  }

  //CRUD

  static Future<LocationObj> readLocation(String uniqueId) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot doc =
        await db.collection('location_db').doc(uniqueId).get();

    return LocationObj(
      position: doc['position'],
      unique_id: doc['unique_id'],
      updated_on: doc['updated_on'].toDate(),
    );
  }

  Future<void> updateLocation(GeoPoint newPosition) async {
    position = newPosition;
    updated_on = DateTime.now();

    await _db.collection('location_db').doc(unique_id).update({
      'position': position,
      'updated_on': updated_on,
    });
  }

  Future<void> createLocation() async {
    await _db.collection('location_db').doc(unique_id).set({
      'position': position,
      'unique_id': unique_id,
      'updated_on': updated_on,
    });
  }

  Future<void> deleteLocation() async {
    await _db.collection('location_db').doc(unique_id).delete();
  }
}
