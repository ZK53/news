import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/book_mark/presentation/cubit/bookmark_cubit/bookmark_cubit.dart';
import 'package:news/features/book_mark/presentation/cubit/bookmark_cubit/bookmark_state.dart';

class ArticleScreen extends StatelessWidget {
  final ArticleModel article;

  const ArticleScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookmarkCubit()..getBookmarks(),
      child: _ArticleView(article: article),
    );
  }
}

class _ArticleView extends StatelessWidget {
  final ArticleModel article;

  const _ArticleView({required this.article});

  @override
  Widget build(BuildContext context) {
    final date = article.publishedAt != null
        ? '${article.publishedAt!.day}/${article.publishedAt!.month}/${article.publishedAt!.year}'
        : '';

    final author = article.author ?? article.sourceName ?? 'Unknown';

    final content =
        article.description ?? article.content ?? 'No content available.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.network(
            article.imageUrl ?? '',
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) {
              return Container(
                height: 300,
                width: double.infinity,
                color: const Color(0xFFE3E5EA),
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 250),

                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F0F0),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),

                      const Spacer(),

                      // Bookmark
                      BlocBuilder<BookmarkCubit, BookmarkState>(
                        builder: (context, state) {
                          bool saved = false;

                          if (state is BookmarkLoadedState) {
                            saved = state.bookmarks.any(
                              (item) => item.url == article.url,
                            );
                          }

                          return IconButton(
                            icon: Icon(
                              saved ? Icons.bookmark : Icons.bookmark_border,
                            ),
                            onPressed: () {
                              context.read<BookmarkCubit>().toggleBookmark(
                                article,
                              );
                            },
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        '$author · $date',
                        style: const TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        content,
                        style: const TextStyle(fontSize: 16, height: 1.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
