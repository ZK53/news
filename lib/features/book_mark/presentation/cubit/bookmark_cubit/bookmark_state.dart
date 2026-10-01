import 'package:news/features/article/data/models/article_model.dart';

abstract class BookmarkState {}

class BookmarkInitialState extends BookmarkState {}

class BookmarkLoadingState extends BookmarkState {}

class BookmarkLoadedState extends BookmarkState {
  final List<ArticleModel> bookmarks;

  BookmarkLoadedState(this.bookmarks);
}

class BookmarkErrorState extends BookmarkState {
  final String errorMsg;

  BookmarkErrorState(this.errorMsg);
}
