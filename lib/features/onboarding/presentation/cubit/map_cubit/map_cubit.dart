import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news/features/onboarding/data/repo/onboarding_repo.dart';
import 'package:news/features/onboarding/presentation/cubit/map_cubit/map_state.dart';

class MapCubit extends Cubit<MapState> {
  final bool isChangingLocation;

  MapCubit({this.isChangingLocation = false}) : super(MapInitState());

  final OnboardingRepo _repo = OnboardingRepo();

  final TextEditingController usernameController = TextEditingController();

  void selectLocation(LatLng location) {
    final isChangingLocation =
        state is MapLocationSelectedState &&
        (state as MapLocationSelectedState).isChangingLocation;

    emit(
      MapLocationSelectedState(
        location,
        isChangingLocation: isChangingLocation,
      ),
    );
  }

  Future<void> initializeLocation() async {
    try {
      emit(MapLoadingState());

      final savedLocation = _repo.getSavedLocation();

      final savedName = _repo.getUserName();

      if (savedName != null) {
        usernameController.text = savedName;
      }

      if (savedLocation != null) {
        emit(MapLocationSelectedState(savedLocation, isChangingLocation: isChangingLocation));
        return;
      }

      final currentLocation = await _repo.getCurrentLocation();

      emit(MapLocationSelectedState(currentLocation, isChangingLocation: isChangingLocation));
    } catch (e) {
      emit(MapErrorState(e.toString()));
    }
  }

  Future<void> confirmLocation() async {
    try {
      if (state is! MapLocationSelectedState) return;

      final location = (state as MapLocationSelectedState).location;

      await _repo.saveLocation(location);

      await _repo.saveUserName(usernameController.text);

      await _repo.completeOnboarding();
    } catch (e) {
      emit(MapErrorState(e.toString()));
    }
  }

  void settingNewLocation() {
    if (state is MapLocationSelectedState) {
      final location = (state as MapLocationSelectedState).location;

      emit(MapLocationSelectedState(location, isChangingLocation: true));
    }
  }
}
