import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';
import '../services/purchase_service.dart';
import 'cart_screen.dart';
import 'my_purchases_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = BookService();
  final purchaseService = PurchaseService();

  List<Book> books = [];
  List<Book> cartItems = [];

  final searchController = TextEditingController();

  int selectedIndex = 0;

  Future<void> searchBooks() async {
    final result = await service.searchBooks(
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

  Widget buildHomeContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Buscar libros...",
                  ),
                ),
              ),
              IconButton(
                onPressed: searchBooks,
                icon: const Icon(Icons.search),
              ),
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
                  leading: book.cover.isNotEmpty
                      ? Image.network(book.cover, width: 50)
                      : const Icon(Icons.menu_book),

                  title: Text(book.title),
                  subtitle: Text(book.author),

                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        cartItems.add(book);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${book.title} agregado al carrito'),
                        ),
                      );
                    },
                    child: const Text('Comprar'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      buildHomeContent(),

      CartScreen(
        cartItems: cartItems,
        purchaseService: purchaseService,
        onClearCart: () {
          setState(() {
            cartItems.clear();
          });
        },
      ),

      const MyPurchasesScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Librería Virtual'),
      ),
      body: screens[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Compras',
          ),
        ],
      ),
    );
  }
}