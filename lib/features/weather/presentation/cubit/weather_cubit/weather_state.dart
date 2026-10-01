import 'package:news/features/weather/data/models/weather_model.dart';

abstract class WeatherState {}

class WeatherInitState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherSuccessState extends WeatherState {
  final WeatherModel weather;
  final String username;

  WeatherSuccessState(this.weather, this.username);
}

class WeatherErrorState extends WeatherState {
  final String errorMsg;
  WeatherErrorState(this.errorMsg);
}
