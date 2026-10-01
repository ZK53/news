import 'package:dartz/dartz.dart';
import 'package:news/core/newtwork/api_helper.dart';
import 'package:news/core/newtwork/endpoints.dart';
import 'package:news/features/article/data/models/article_model.dart';

class ArticleRepo {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Either<String, List<ArticleModel>>> getEverything({
    required String query,
  }) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: Endpoints.everything,
        queryParams: {
          'q': query,
          'apiKey': '836086f05b344448a16dd41ee51c6320',
          'language': 'en',
        },
      );

      final data = response.data as Map<String, dynamic>;

      final articlesJson = data['articles'] as List;

      final articles = articlesJson
          .map(
            (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
          )
          .toList();

      return right(articles);
    } catch (e) {
      return left(_apiHelper.handleException(e));
    }
  }

  Future<Either<String, List<ArticleModel>>> getTopHeadlines({
    String? category,
  }) async {
    try {
      final response = await _apiHelper.getRequest(
        endpoint: Endpoints.topHeadlines,
        queryParams: {
          'country': 'us',
          'category': category,
          'apiKey': '836086f05b344448a16dd41ee51c6320',
        },
      );

      final data = response.data as Map<String, dynamic>;

      final articlesJson = data['articles'] as List;

      final articles = articlesJson
          .map(
            (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
          )
          .toList();

      return right(articles);
    } catch (e) {
      return left(_apiHelper.handleException(e));
    }
  }
}
