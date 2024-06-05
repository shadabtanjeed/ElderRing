import 'package:flutter/material.dart';
import 'package:elder_ring/models/locationObj.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Users/users.dart';

class ShareLocation extends StatefulWidget {
  const ShareLocation({super.key});

  @override
  _ShareLocationState createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  LocationObj locationObj = LocationObj(
    position: const GeoPoint(0, 0),
    unique_id: Users.getElderlyUsername(),
    updated_on: DateTime.now(),
  );

  Location location = Location();

  @override
  void initState() {
    super.initState();
    updateLocation();
    startTransmission();
  }

  @override
  void dispose() {
    location.enableBackgroundMode(enable: false);
    super.dispose();
  }

  void startTransmission() {
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        locationObj = LocationObj(
          position:
              GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
          unique_id: locationObj.unique_id,
          updated_on: DateTime.now(),
        );
      });
      locationObj.updateLocation(locationObj.position);
    });
  }

  void updateLocation() async {
    LocationData currentLocation = await location.getLocation();
    locationObj = LocationObj(
      position: GeoPoint(currentLocation.latitude!, currentLocation.longitude!),
      unique_id: locationObj.unique_id,
      updated_on: DateTime.now(),
    );

    bool exists = await LocationObj.exists(locationObj.unique_id);
    if (!exists) {
      await locationObj.createLocation();
    } else {
      await locationObj.updateLocation(locationObj.position);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing Location'),
      ),
      body: Center(
        child: locationObj.position == null
            ? const CircularProgressIndicator()
            : Text(
                'Location:\nLat: ${locationObj.position.latitude}, Long: ${locationObj.position.longitude}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateLocation,
        tooltip: 'Update Location',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
