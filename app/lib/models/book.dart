class Book {
  final String title;
  final String author;
  final String cover;

  Book({
    required this.title,
    required this.author,
    required this.cover,
  });

  factory Book.fromJson(Map<String, dynamic> json) {

    String coverUrl = '';

    if (json['cover_i'] != null) {
      coverUrl =
          'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg';
    }

    return Book(
      title: json['title'] ?? '',
      author: json['author_name'] != null
          ? json['author_name'][0]
          : 'Desconocido',
      cover: coverUrl,
    );
  }
}