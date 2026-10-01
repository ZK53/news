import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/article/presentation/cubit/article_cubit.dart';
import 'package:news/features/article/presentation/cubit/article_state.dart';
import 'package:news/features/article/presentation/views/article.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticleCubit()..getEverything(query: query),
      child: _SearchResultsView(query: query),
    );
  }
}

class _SearchResultsView extends StatelessWidget {
  final String query;

  const _SearchResultsView({required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Search results',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 8),

            BlocBuilder<ArticleCubit, ArticleState>(
              builder: (context, state) {
                if (state is ArticleLoadingState) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is ArticleErrorState) {
                  return Expanded(child: Center(child: Text(state.errorMsg)));
                }

                if (state is ArticleSuccessState) {
                  final articles = state.articles;

                  return Expanded(
                    child: articles.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: articles.length,
                            itemBuilder: (_, index) {
                              return _tile(articles[index], context);
                            },
                          ),
                  );
                }

                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(ArticleModel article, BuildContext context) {
    final date = article.publishedAt != null
        ? '${article.publishedAt!.day}/${article.publishedAt!.month}/${article.publishedAt!.year}'
        : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () {
          _openArticle(context, article);
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '${article.author ?? article.sourceName ?? 'Unknown'} · $date',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            _img(article.imageUrl ?? '', w: 80, h: 58, r: 8),
          ],
        ),
      ),
    );
  }

  Widget _img(String url, {double? w, double? h, double r = 0}) {
    if (url.isEmpty) {
      return Container(width: w, height: h, color: const Color(0xFFE3E5EA));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Image.network(
        url,
        width: w,
        height: h,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return Container(width: w, height: h, color: const Color(0xFFE3E5EA));
        },
      ),
    );
  }

  void _openArticle(BuildContext context, ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleScreen(article: article)),
    );
  }
}
