import 'package:flutter/material.dart';
import 'locationServices.dart';
import 'showOnMaps.dart';

class MapMenu extends StatefulWidget {
  const MapMenu({super.key});

  @override
  State<MapMenu> createState() => _MapMenuState();
}

class _MapMenuState extends State<MapMenu> {
  String latitude = '';
  String longitude = '';

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
                LocationServices().fetchLocation().then((position) {
                  setState(() {
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  });
                });
              },
              child: const Text('Fetch Location'),
            ),
            const SizedBox(height: 20),
            Text(
              'Latitude: $latitude',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Longitude: $longitude',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LocationMapPage(),
                  ),
                );
              },
              child: const Text('Show on Map'),
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
