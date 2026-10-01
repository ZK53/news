import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/core/theme/app_colors.dart';
import 'package:news/features/article/data/models/article_model.dart';
import 'package:news/features/article/presentation/views/article.dart';
import 'package:news/features/book_mark/presentation/cubit/bookmark_cubit/bookmark_cubit.dart';
import 'package:news/features/book_mark/presentation/cubit/bookmark_cubit/bookmark_state.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookmarkCubit()..getBookmarks(),
      child: _BookmarkView(),
    );
  }
}

class _BookmarkView extends StatelessWidget {
  const _BookmarkView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 123,
            width: double.infinity,
            color: AppColors.headerBg,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Bookmark',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<BookmarkCubit, BookmarkState>(
              builder: (context, state) {
                if (state is BookmarkLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BookmarkErrorState) {
                  return Center(child: Text(state.errorMsg));
                }

                if (state is BookmarkLoadedState) {
                  final bookmarks = state.bookmarks;

                  if (bookmarks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No Bookmarks Yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    itemCount: bookmarks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final article = bookmarks[index];

                      return _BookmarkTile(
                        article: article,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ArticleScreen(article: article),
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<BookmarkCubit>().toggleBookmark(article);
                        },
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BookmarkTile({
    required this.article,
    required this.onTap,
    required this.onDelete,
  });

  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Bookmark?'),
          content: Text(
            article.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Yes, Delete'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final date = article.publishedAt != null
        ? '${article.publishedAt!.day}/${article.publishedAt!.month}/${article.publishedAt!.year}'
        : '';

    final author = article.author ?? article.sourceName ?? 'Unknown';

    return Dismissible(
      key: ValueKey(article.url ?? article.title),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        onDelete();
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(height: 4),
                  Text(
                    '$author · $date',
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            ClipRRect(borderRadius: BorderRadius.circular(12), child: _image()),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    if (article.imageUrl == null || article.imageUrl!.isEmpty) {
      return Container(
        width: 112,
        height: 80,
        color: const Color(0xFFE3E5EA),
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: Colors.grey,
        ),
      );
    }

    return Image.network(
      article.imageUrl!,
      width: 112,
      height: 80,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) {
        return Container(
          width: 112,
          height: 80,
          color: const Color(0xFFE3E5EA),
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
