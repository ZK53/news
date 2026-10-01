import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news/core/cache/cache_helper.dart';
import 'package:news/core/cache/cache_keys.dart';
import 'package:news/core/helper/location_service.dart';

class OnboardingRepo {
  Future<LatLng> getCurrentLocation() async {
    final Position position = await LocationService.determinePosition();

    return LatLng(position.latitude, position.longitude);
  }

  Future<void> saveLocation(LatLng location) async {
    await CacheHelper.setValue(
      key: CacheKeys.latitude,
      value: location.latitude,
    );

    await CacheHelper.setValue(
      key: CacheKeys.longitude,
      value: location.longitude,
    );
  }

  LatLng? getSavedLocation() {
    final latitude = CacheHelper.getValue(key: CacheKeys.latitude);
    final longitude = CacheHelper.getValue(key: CacheKeys.longitude);

    if (latitude == null || longitude == null) {
      return null;
    }

    return LatLng(latitude as double, longitude as double);
  }
}
