import 'package:geolocator/geolocator.dart';

class LocationServices{
  Future<LocationPermission> getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<Position> fetchLocation() async {
    LocationPermission permission = await getPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return currentPosition;
    }
  }
}