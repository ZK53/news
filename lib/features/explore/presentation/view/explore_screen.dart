import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/widgets/app_bottom_nav.dart';
import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/article/presentation/cubit/article_cubit.dart';
import 'package:news/features/article/presentation/cubit/article_state.dart';
import 'package:news/features/article/presentation/views/article.dart';
import 'package:news/features/book_mark/presentation/view/bookmark_screen.dart';
import 'package:news/features/home/presentation/view/home_screen.dart';
import 'package:news/features/weather/presentation/view/weather_screen.dart';

import 'search_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ArticleCubit()..getTopHeadlines(),
      child: _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  final List<String> categories = [
    'Technology',
    'Business',
    'Sports',
    'Science',
    'Health',
    'Entertainment',
  ];

  String _selected = 'Technology';

  void _onNavTap(int index) {
    if (index == 1) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;

      case 2:
        screen = const BookmarkScreen();
        break;

      default:
        screen = const WeatherScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleCubit, ArticleState>(
      builder: (context, state) {
        if (state is ArticleLoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ArticleErrorState) {
          return Scaffold(body: Center(child: Text(state.errorMsg)));
        }

        if (state is ArticleSuccessState) {
          final articles = state.articles;

          return Scaffold(
            body: Column(
              children: [
                Container(
                  color: const Color(0xFFE8ECF8),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 16, 12),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SearchScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 34,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: categories.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (_, i) {
                              final category = categories[i];
                              final selected = category == _selected;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selected = category;
                                  });

                                  context.read<ArticleCubit>().getTopHeadlines(
                                    category: category.toLowerCase(),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFFE3E8F7)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: selected
                                          ? const Color(0xFFE3E8F7)
                                          : const Color(0xFFE5E7EB),
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: articles.isEmpty
                      ? const Center(child: Text('No articles'))
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                          children: [
                            InkWell(
                              onTap: () =>
                                  _openArticle(context, articles.first),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _img(
                                    articles.first.imageUrl ?? '',
                                    w: 366,
                                    h: 208,
                                    r: 8,
                                  ),

                                  const SizedBox(height: 16),

                                  Text(
                                    articles.first.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  _articleAuthor(articles.first),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            for (final article in articles.skip(1))
                              _articleTile(article),
                          ],
                        ),
                ),
              ],
            ),
            bottomNavigationBar: AppBottomNav(
              currentIndex: 1,
              onTap: _onNavTap,
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _articleTile(ArticleModel article) {
    return InkWell(
      onTap: () => _openArticle(context, article),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  _articleAuthor(article),
                ],
              ),
            ),

            const SizedBox(width: 16),

            _img(article.imageUrl ?? '', w: 112, h: 80, r: 8),
          ],
        ),
      ),
    );
  }

  Widget _articleAuthor(ArticleModel article) {
    final date = article.publishedAt != null
        ? '${article.publishedAt!.day}/${article.publishedAt!.month}/${article.publishedAt!.year}'
        : '';

    return Text(
      '${article.author ?? article.sourceName ?? 'Unknown'} · $date',
      style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
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
