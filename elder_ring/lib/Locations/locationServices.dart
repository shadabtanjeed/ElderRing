import 'package:location/location.dart';

class LocationServices {
  Future<bool> getPermission() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<LocationData> fetchLocation() async {
    Location location = Location();
    bool permission = await getPermission();
    if (!permission) {
      throw Exception('Location permission denied');
    }

    LocationData currentPosition = await location.getLocation();
    return currentPosition;
  }
}
