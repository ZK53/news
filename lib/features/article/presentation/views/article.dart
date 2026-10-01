import 'package:flutter/material.dart';
import 'package:news/features/article/data/models/article_model.dart';

class ArticleScreen extends StatefulWidget {
  final ArticleModel article;

  const ArticleScreen({super.key, required this.article});

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

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

                      IconButton(
                        icon: Icon(
                          saved ? Icons.bookmark : Icons.bookmark_border,
                        ),
                        onPressed: () {
                          setState(() {
                            saved = !saved;
                          });
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
