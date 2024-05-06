import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'locationServices.dart';
import 'dart:async';

class ShowLocationOnMap extends StatefulWidget {
  const ShowLocationOnMap({super.key});

  @override
  _ShowLocationOnMapState createState() => _ShowLocationOnMapState();
}

class _ShowLocationOnMapState extends State<ShowLocationOnMap> {
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
      LocationData locationData = await locationServices.fetchLocation();
      setState(() {
        currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
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
      appBar: AppBar(),
      body: GoogleMap(
        mapType: MapType.normal,
        // buildingsEnabled: true,
        // myLocationEnabled: true,
        // myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          target: currentLocation,
          zoom: 15,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
