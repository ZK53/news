class ArticleModel {
  final String? author;
  final String title;
  final String? description;
  final String? url;
  final String? imageUrl;
  final DateTime? publishedAt;
  final String? content;
  final String? sourceName;

  ArticleModel({
    this.author,
    required this.title,
    this.description,
    this.url,
    this.imageUrl,
    this.publishedAt,
    this.content,
    this.sourceName,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      author: json['author'],
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'],
      imageUrl: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      content: json['content'],
      sourceName: json['source']?['name'],
    );
  }
}
