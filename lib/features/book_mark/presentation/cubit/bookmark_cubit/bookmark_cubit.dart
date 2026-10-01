import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/book_mark/data/repo/bookmark_repo.dart';
import 'package:news/features/book_mark/presentation/cubit/bookmark_cubit/bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit() : super(BookmarkInitialState());

  final BookmarkRepo _repo = BookmarkRepo();

  Future<void> getBookmarks() async {
    emit(BookmarkLoadingState());

    try {
      final bookmarks = await _repo.getBookmarks();
      emit(BookmarkLoadedState(bookmarks));
    } catch (e) {
      emit(BookmarkErrorState('Failed to load bookmarks'));
    }
  }

  Future<void> toggleBookmark(ArticleModel article) async {
    try {
      final isSaved = await _repo.isBookmarked(article);

      if (isSaved) {
        await _repo.removeBookmark(article);
      } else {
        await _repo.saveBookmark(article);
      }

      final bookmarks = await _repo.getBookmarks();

      emit(BookmarkLoadedState(bookmarks));
    } catch (e) {
      emit(BookmarkErrorState('Failed to update bookmark'));
    }
  }

  Future<bool> isBookmarked(ArticleModel article) {
    return _repo.isBookmarked(article);
  }
}
