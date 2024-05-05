import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({super.key});

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  GoogleMapController? mapController;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> path = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Location'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _db.collection('location_db').doc('Untouchable').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          GeoPoint position = snapshot.data!['position'];
          LatLng currentLocation =
              LatLng(position.latitude, position.longitude);
          mapController?.moveCamera(CameraUpdate.newLatLng(currentLocation));

          markers.clear();
          markers.add(Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentLocation,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ));

          path.add(currentLocation);
          polylines.clear();
          polylines.add(Polyline(
            polylineId: const PolylineId('path'),
            points: path,
            color: Colors.green,
          ));

          return GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 14,
            ),
            markers: markers,
            polylines: polylines,
          );
        },
      ),
    );
  }
}
