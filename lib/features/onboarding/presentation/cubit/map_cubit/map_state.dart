import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {}

class MapInitState extends MapState {}

class MapLoadingState extends MapState {}

class MapLocationSelectedState extends MapState {
  final LatLng location;
  MapLocationSelectedState(this.location);
}

class MapErrorState extends MapState {
  final String errorMsg;
  MapErrorState(this.errorMsg);
}
