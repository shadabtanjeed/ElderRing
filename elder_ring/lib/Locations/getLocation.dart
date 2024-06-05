import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Users/users.dart';
import 'package:elder_ring/models/locationObj.dart';

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
  Future<DocumentSnapshot>? _initialData;

  @override
  void initState() {
    super.initState();
    _initialData = _db.collection('location_db').doc(Users.getElderlyUsername()).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _initialData,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.data == null) {
          return const Text('No data');
        }

        LocationObj locationObj = LocationObj(
          position: snapshot.data!['position'],
          unique_id: snapshot.data!['unique_id'],
          updated_on: snapshot.data!['updated_on'].toDate(),
        );

        GeoPoint position = locationObj.position;
        LatLng currentLocation = LatLng(position.latitude, position.longitude);

        String appBarTitle = 'Getting Live Location';
        String markerTitle = 'Current Location';
        BitmapDescriptor markerColor =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);

        if (!locationObj.isLocationUpToDate(locationObj.updated_on)) {
          appBarTitle = 'Last Known Location';
          markerTitle = 'Last seen on ${locationObj.updated_on}';
          markerColor =
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
        }

        markers.clear();
        Marker currentLocationMarker = Marker(
          markerId: const MarkerId('currentLocation'),
          position: currentLocation,
          infoWindow: InfoWindow(
            title: markerTitle,
          ),
          icon: markerColor,
        );
        markers.add(currentLocationMarker);

        return Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
          ),
          body: GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              Future.delayed(Duration(milliseconds: 500)).then((_) {
                controller.animateCamera(
                  CameraUpdate.newLatLngZoom(currentLocationMarker.position, 15),
                );
              });
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation,
              zoom: 15,
            ),
            markers: markers,
            polylines: polylines,
          ),
        );
      },
    );
  }
}