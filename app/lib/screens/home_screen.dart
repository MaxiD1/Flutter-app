import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

  final service = BookService();

  List<Book> books = [];

  final searchController =
      TextEditingController();

  Future<void> searchBooks() async {

    final result =
        await service.searchBooks(
      searchController.text,
    );

    setState(() {
      books = result;
    });
  }

  @override
  void initState() {
    super.initState();
    searchController.text = "programming";
    searchBooks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Librería Virtual',
        ),
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller:
                        searchController,
                    decoration:
                        const InputDecoration(
                      hintText:
                          "Buscar libros...",
                    ),
                  ),
                ),

                IconButton(
                  onPressed: searchBooks,
                  icon: const Icon(
                    Icons.search,
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {

                final book = books[index];

                return Card(
                  child: ListTile(

                    leading:
                        book.cover.isNotEmpty
                            ? Image.network(
                                book.cover,
                                width: 50,
                              )
                            : const Icon(
                                Icons.menu_book,
                              ),

                    title: Text(
                      book.title,
                    ),

                    subtitle: Text(
                      book.author,
                    ),

                    trailing:
                        ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'Comprar',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}