import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:news/core/cache/cache_helper.dart';
import 'package:news/core/cache/cache_keys.dart';
import 'package:news/core/newtwork/api_helper.dart';
import 'package:news/core/newtwork/endpoints.dart';
import 'package:news/features/weather/data/models/weather_model.dart';

class WeatherRepo {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Either<String, WeatherModel>> getWeather() async {
    final latitude = CacheHelper.getValue(key: CacheKeys.latitude) as double?;

    final longitude = CacheHelper.getValue(key: CacheKeys.longitude) as double?;

    if (latitude == null || longitude == null) {
      return left('Location not found');
    }

    try {
      final response = await _apiHelper.getRequest(
        endpoint: Endpoints.weather,
        queryParams: {
          'lat': latitude,
          'lon': longitude,
          'appid': '39ef56aa87e0f9d833e66cd9111de959',
          'units': 'metric',
        },
      );

      final jsonResponse = response.data as Map<String, dynamic>;

      return right(WeatherModel.fromJson(jsonResponse));
    } catch (e) {
      return left(_apiHelper.handleException(e));
    }
  }

  Future<void> saveWeather(WeatherModel weather) async {
    await CacheHelper.setValue(
      key: CacheKeys.weather,
      value: jsonEncode({
        'cityName': weather.cityName,
        'country': weather.country,
        'temperature': weather.temperature,
        'feelsLike': weather.feelsLike,
        'mainDescription': weather.mainDescription,
        'description': weather.description,
        'icon': weather.icon,
        'pressure': weather.pressure,
        'humidity': weather.humidity,
        'windSpeed': weather.windSpeed,
      }),
    );
  }

  WeatherModel? getCachedWeather() {
    final cachedData = CacheHelper.getValue(key: CacheKeys.weather);

    if (cachedData == null) {
      return null;
    }

    final jsonData = jsonDecode(cachedData as String);

    return WeatherModel.fromJson(jsonData);
  }
}
