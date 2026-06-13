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
}