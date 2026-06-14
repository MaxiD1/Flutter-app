class Book {
  final String title;
  final String author;
  final String cover;
  final String id;
  final String description; // Nueva propiedad para la sinopsis

  Book({
    required this.title,
    required this.author,
    required this.cover,
    required this.id,
    this.description = '', // Por defecto vacía si no viene en el JSON
  });

  // Propiedad calculada para simular un precio real y único por libro
  int get price {
    // Usamos el largo del título y el ID para generar un número coherente entre $8.000 y $25.000
    final base = (title.length * 350) + (id.length * 120);
    final calculatedPrice = (base % 17000) + 8500;
    // Retornamos el precio redondeado a la centena más cercana para que se vea real
    return (calculatedPrice ~/ 100) * 100;
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    String coverUrl = '';

    if (json['cover_i'] != null) {
      coverUrl = 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg';
    }

    // Open Library a veces guarda la descripción en campos diferentes según el endpoint
    String rawDescription = '';
    if (json['first_sentence'] != null) {
      rawDescription = json['first_sentence'] is List 
          ? json['first_sentence'][0] 
          : json['first_sentence'];
    }

    return Book(
      title: json['title'] ?? '',
      author: json['author_name'] != null ? json['author_name'][0] : 'Desconocido',
      cover: coverUrl,
      id: json['key'] ?? '',
      description: rawDescription,
    );
  }
}