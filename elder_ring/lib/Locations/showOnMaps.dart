import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'locationServices.dart';
import 'dart:async';

class LocationMapPage extends StatefulWidget {
  const LocationMapPage({super.key});

  @override
  _LocationMapPageState createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  LatLng currentLocation = const LatLng(0, 0);
  final LocationServices locationServices = LocationServices();
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    try {
      Position position = await locationServices.fetchLocation();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      GoogleMapController controller = await _controller.future;
      controller.moveCamera(CameraUpdate.newLatLng(currentLocation));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = {};
    markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: currentLocation,
        infoWindow: const InfoWindow(
          title: 'Current Location',
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 14.4746,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
