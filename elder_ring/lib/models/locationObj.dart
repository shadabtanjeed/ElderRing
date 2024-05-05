import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class LocationObj {
  GeoPoint position;
  final String unique_id;
  DateTime updated_on;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Location location = Location();

  LocationObj(
      {required this.position,
      required this.unique_id,
      required this.updated_on});

  Future<void> update() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData _currentLocation = await location.getLocation();

    this.position =
        GeoPoint(_currentLocation.latitude!, _currentLocation.longitude!);
    this.updated_on = DateTime.now();

    _db.collection('location_share').doc(this.unique_id).set({
      'position': this.position,
      'unique_id': this.unique_id,
      'updated_on': this.updated_on,
    });
  }

  //CRUD

  static Future<LocationObj> fromFirestore(String unique_id) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    DocumentSnapshot doc =
        await _db.collection('location_share').doc(unique_id).get();

    return LocationObj(
      position: doc['position'],
      unique_id: doc['unique_id'],
      updated_on: doc['updated_on'].toDate(),
    );
  }

  Future<void> updateLocation(GeoPoint newPosition) async {
    this.position = newPosition;
    this.updated_on = DateTime.now();

    await _db.collection('location_share').doc(this.unique_id).update({
      'position': this.position,
      'updated_on': this.updated_on,
    });
  }

  Future<void> createLocation() async {
    await _db.collection('location_share').doc(this.unique_id).set({
      'position': this.position,
      'unique_id': this.unique_id,
      'updated_on': this.updated_on,
    });
  }

  Future<void> deleteLocation() async {
    await _db.collection('location_share').doc(this.unique_id).delete();
  }
}
