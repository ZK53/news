import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/weather/data/models/weather_model.dart';

abstract class HomeState {}

class HomeInitState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final WeatherModel weather;
  final List<ArticleModel> articles;

  HomeSuccessState({required this.weather, required this.articles});
}

class HomeErrorState extends HomeState {
  final String errorMsg;

  HomeErrorState(this.errorMsg);
}
