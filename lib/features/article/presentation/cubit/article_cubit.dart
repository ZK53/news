import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/article/data/repo/article_repo.dart';
import 'package:news/features/article/presentation/cubit/article_state.dart';

class ArticleCubit extends Cubit<ArticleState> {
  ArticleCubit() : super(ArticleInitState());

  final ArticleRepo _repo = ArticleRepo();

  Future<void> getEverything({required String query}) async {
    emit(ArticleLoadingState());

    final result = await _repo.getEverything(query: query);

    result.fold(
      (errorMsg) {
        emit(ArticleErrorState(errorMsg));
      },
      (articles) {
        emit(ArticleSuccessState(articles));
      },
    );
  }

  Future<void> getTopHeadlines({String? category}) async {
    emit(ArticleLoadingState());

    final result = await _repo.getTopHeadlines(category: category);

    result.fold(
      (errorMsg) {
        emit(ArticleErrorState(errorMsg));
      },
      (articles) {
        emit(ArticleSuccessState(articles));
      },
    );
  }
}
