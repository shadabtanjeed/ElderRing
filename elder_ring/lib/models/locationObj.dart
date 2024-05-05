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

  Future<void> updateLocation() async {
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
}
