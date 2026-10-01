import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/article/data/repo/article_repo.dart';
import 'package:news/features/home/presentation/cubit/home_state.dart';
import 'package:news/features/weather/data/repo/weather_repo.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitState());

  final WeatherRepo _weatherRepo = WeatherRepo();
  final ArticleRepo _articleRepo = ArticleRepo();

  Future<void> getHomeData() async {
    emit(HomeLoadingState());

    final weatherResult = await _weatherRepo.getWeather();

    final articlesResult = await _articleRepo.getTopHeadlines();

    if (weatherResult.isLeft() || articlesResult.isLeft()) {
      final error = weatherResult.fold(
        (error) => error,
        (_) => articlesResult.fold((error) => error, (_) => ''),
      );

      emit(HomeErrorState(error));
      return;
    }

    final weather = weatherResult.getOrElse(() => throw Exception());

    final articles = articlesResult.getOrElse(() => []);

    await _weatherRepo.saveWeather(weather);

    emit(HomeSuccessState(weather: weather, articles: articles));
  }
}
