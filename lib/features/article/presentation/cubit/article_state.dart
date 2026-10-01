import 'package:news/features/article/data/models/article_model.dart';

abstract class ArticleState {}

class ArticleInitState extends ArticleState {}

class ArticleLoadingState extends ArticleState {}

class ArticleSuccessState extends ArticleState {
  final List<ArticleModel> articles;

  ArticleSuccessState(this.articles);
}

class ArticleErrorState extends ArticleState {
  final String errorMsg;

  ArticleErrorState(this.errorMsg);
}
