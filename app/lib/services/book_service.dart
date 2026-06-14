import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookService {

  Future<List<Book>> searchBooks(
      String query,
      ) async {

    final url =
        'https://openlibrary.org/search.json?q=$query';

    final response =
        await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      final data =
          json.decode(response.body);

      List docs = data['docs'];

      return docs
          .map((e) => Book.fromJson(e))
          .toList();
    }

    throw Exception('Error al cargar libros');
  }
  // Añade este método dentro de tu clase BookService
  Future<String> getBookDescription(String bookKey) async {
    try {
      // openlibrary.org/works/OLXXXXXW.json
      final url = Uri.parse('https://openlibrary.org$bookKey.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['description'] != null) {
          // A veces viene como un String directo, a veces como un Map con un campo 'value'
          if (data['description'] is Map) {
            return data['description']['value'] ?? '';
          }
          return data['description'].toString();
        }
      }
    } catch (e) {
      print('Error cargando descripción: $e');
    }
    return ''; // Si falla o no tiene, retorna vacío
  }
}