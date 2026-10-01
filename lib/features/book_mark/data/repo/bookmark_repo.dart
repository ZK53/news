import 'dart:convert';

import 'package:news/core/cache/cache_helper.dart';
import 'package:news/core/cache/cache_keys.dart';
import 'package:news/features/article/data/models/article_model.dart';

class BookmarkRepo {
  Future<List<ArticleModel>> getBookmarks() async {
    final cachedData = CacheHelper.getValue(key: CacheKeys.bookmarks);

    if (cachedData == null) {
      return [];
    }

    try {
      final List<dynamic> data = jsonDecode(cachedData as String);

      return data
          .map(
            (article) => ArticleModel.fromJson(article as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveBookmark(ArticleModel article) async {
    final bookmarks = await getBookmarks();

    final exists = bookmarks.any((item) => item.url == article.url);

    if (exists) {
      return;
    }

    bookmarks.add(article);

    await _saveBookmarks(bookmarks);
  }

  Future<void> removeBookmark(ArticleModel article) async {
    final bookmarks = await getBookmarks();

    bookmarks.removeWhere((item) => item.url == article.url);

    await _saveBookmarks(bookmarks);
  }

  Future<bool> isBookmarked(ArticleModel article) async {
    final bookmarks = await getBookmarks();

    return bookmarks.any((item) => item.url == article.url);
  }

  Future<void> _saveBookmarks(List<ArticleModel> bookmarks) async {
    final data = bookmarks.map((article) {
      return {
        'author': article.author,
        'title': article.title,
        'description': article.description,
        'url': article.url,
        'urlToImage': article.imageUrl,
        'publishedAt': article.publishedAt?.toIso8601String(),
        'content': article.content,
        'source': {'name': article.sourceName},
      };
    }).toList();

    await CacheHelper.setValue(
      key: CacheKeys.bookmarks,
      value: jsonEncode(data),
    );
  }
}
