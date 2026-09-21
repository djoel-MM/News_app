class NewsArticle {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;
  final Source? source;

  NewsArticle({
    this.title, this.description, this.url, this.urlToImage,
    this.publishedAt, this.content, this.source,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      source: json['source'] != null ? Source.fromJson(json['source']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt,
        'content': content,
        'source': source?.toJson(),
      };

  /// Judul bersih: API kadang menyisipkan " - Sumber" di akhir judul.
  String get cleanTitle {
    final t = title ?? '';
    final idx = t.lastIndexOf(' - ');
    return idx > 0 ? t.substring(0, idx) : t;
  }

  String get sourceName => source?.name ?? 'Sumber';
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
