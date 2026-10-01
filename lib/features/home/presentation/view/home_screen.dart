import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/helper/date_time_helper.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/article/presentation/views/article.dart';
import 'package:news/features/home/presentation/cubit/home_cubit.dart';
import 'package:news/features/home/presentation/cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..getHomeData(),
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void openArticle(BuildContext context, ArticleModel article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticleScreen(article: article)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is HomeErrorState) {
          return Scaffold(body: Center(child: Text(state.errorMsg)));
        }

        if (state is HomeSuccessState) {
          return _homeBuilder(context, state, openArticle);
        }

        return Scaffold(body: Center(child: Text("Somthing Happened")));
      },
    );
  }
}

Widget _homeBuilder(
  BuildContext context,
  HomeSuccessState state,
  Function openArticle,
) {
  return RefreshIndicator(
    onRefresh: () => context.read<HomeCubit>().getHomeData(),
    child: Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFE8ECF8),

            padding: const EdgeInsets.fromLTRB(24, 50, 24, 16),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      '${DateTimeHelper.getGreeting()},\n${state.username}',

                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      DateTimeHelper.getFormattedDate(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                Text(
                  '${state.weather.mainDescription} '
                  '${state.weather.temperature.round()}°C',
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SizedBox(
                  height: 206,
                  child: PageView.builder(
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      final article = state.articles[index];

                      return GestureDetector(
                        onTap: () => openArticle(context, article),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildArticleImage(article.imageUrl),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: Colors.black54,
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          article.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        article.author ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Most Popular',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'See More',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 270,

                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,

                    itemCount: state.articles.length,

                    itemBuilder: (context, index) {
                      final article = state.articles[index];

                      return GestureDetector(
                        onTap: () => openArticle(context, article),

                        child: Container(
                          width: 180,

                          margin: const EdgeInsets.only(right: 14),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),

                                child: _buildArticleImage(article.imageUrl),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                article.title,

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                article.sourceName ?? 'News',

                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildArticleImage(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    return Container(
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_not_supported, size: 40),
    );
  }

  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    errorBuilder: (_, _, _) {
      return Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported, size: 40),
      );
    },
  );
}
