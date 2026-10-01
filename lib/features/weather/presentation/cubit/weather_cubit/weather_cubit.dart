import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/weather/data/repo/weather_repo.dart';
import 'package:news/features/weather/presentation/cubit/weather_cubit/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitState());

  final WeatherRepo _repo = WeatherRepo();

  Future<void> getWeather() async {
    emit(WeatherLoadingState());

    final result = await _repo.getWeather();

    result.fold(
      (errorMsg) => emit(WeatherErrorState(errorMsg)),
      (weatherModel) => emit(WeatherSuccessState(weatherModel)),
    );
  }
}
