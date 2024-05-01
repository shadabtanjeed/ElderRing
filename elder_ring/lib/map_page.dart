import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MaPage extends StatefulWidget {
  const MaPage({super.key});

  @override
  State<MaPage> createState() => _MaPageState();
}

class _MaPageState extends State<MaPage> {
  String latitude = '';
  String longitude = '';

  getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print("Location permission denied"); // should use widget to show errormsg

      permission = await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = currentPosition.latitude.toString();
        longitude = currentPosition.longitude.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                getLocation();
              },
              child: const Text('Fetch Location'),
            ),
            const SizedBox(height: 20),
            Text(
              'Latitude: $latitude',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Longitude: $longitude',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigates back to the previous screen (HomePage)
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
