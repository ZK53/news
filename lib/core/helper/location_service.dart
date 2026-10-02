import 'package:geolocator/geolocator.dart';

abstract class LocationService {
  static Future<Position> determinePosition() async {
    // Check if GPS / Location Service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Open device location settings
      await Geolocator.openLocationSettings();

      // Check again after user returns
      serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    // Check app permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Open app settings because permission cannot be requested again
      await Geolocator.openAppSettings();

      return Future.error('Location permissions are permanently denied.');
    }

    // Permission granted + GPS enabled
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
