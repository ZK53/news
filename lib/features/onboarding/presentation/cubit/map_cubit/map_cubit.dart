import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:news/features/onboarding/data/repo/onboarding_repo.dart';
import 'package:news/features/onboarding/presentation/cubit/map_cubit/map_state.dart';

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitState());

  final OnboardingRepo _repo = OnboardingRepo();

  void selectLocation(LatLng location) {
    emit(MapLocationSelectedState(location));
  }

  Future<void> initializeLocation() async {
    try {
      emit(MapLoadingState());

      final savedLocation = _repo.getSavedLocation();

      if (savedLocation != null) {
        emit(MapLocationSelectedState(savedLocation));
        return;
      }

      final currentLocation = await _repo.getCurrentLocation();

      emit(MapLocationSelectedState(currentLocation));
    } catch (e) {
      emit(MapErrorState(e.toString()));
    }
  }

  Future<void> confirmLocation() async {
    try {
      if (state is! MapLocationSelectedState) return;

      final location = (state as MapLocationSelectedState).location;

      await _repo.saveLocation(location);
      await _repo.completeOnboarding();
    } catch (e) {
      emit(MapErrorState(e.toString()));
    }
  }
}
