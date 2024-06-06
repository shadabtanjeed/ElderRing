import 'package:flutter/material.dart';
import 'locationServices.dart';
import 'shareLocation.dart';
import 'crudscreen.dart';
import 'getLocation.dart';
import 'package:elder_ring/Users/users.dart';
import 'package:elder_ring/EmergencyMeds/EMDBHander.dart';
import 'package:elder_ring/EmergencyMeds/AddEM.dart';
import 'package:elder_ring/EmergencyMeds/GetEMNameList.dart';

class MapMenu extends StatefulWidget {
  const MapMenu({Key? key}) : super(key: key);

  @override
  State<MapMenu> createState() => _MapMenuState();
}

class _MapMenuState extends State<MapMenu> {
  String latitude = '';
  String longitude = '';
  static const Color mapPageColor = Color(0xFF2798E4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Menu'),
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
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
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
                  MaterialPageRoute(builder: (context) => const GetLocation()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Show Live Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShareLocation()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Fire Share'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CrudScreen()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('CRUDs'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Go Back'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Users'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Text(
                                'Elderly Username: ${Users.getElderlyUsername()}'),
                            Text(
                                'Care Provider Username: ${Users.getCareProviderUsername()}'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Show Users'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEntryPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EntryNamesPage()),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(mapPageColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Get Entry Names'),
            ),
          ],
        ),
      ),
    );
  }
}
