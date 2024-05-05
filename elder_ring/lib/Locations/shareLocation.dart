import 'package:flutter/material.dart';
import 'package:elder_ring/models/locationObj.dart';
// import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShareLocation extends StatefulWidget {
  const ShareLocation({super.key});

  @override
  _ShareLocationState createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  LocationObj locationObj = LocationObj(
      position: const GeoPoint(0, 0),
      unique_id: "theOldMan", // replace this with the actual unique_id
      updated_on: DateTime.now());

  @override
  void initState() {
    super.initState();
    locationObj.update();
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
    );
  }
}
