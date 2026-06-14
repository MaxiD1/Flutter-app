import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/book_service.dart';
import '../services/purchase_service.dart';
import 'cart_screen.dart';
import 'my_purchases_screen.dart';
import 'book_detail_screen.dart'; // Importamos la nueva pantalla

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

  // Paleta de colores UI de la foto 2
  static const Color scaffoldBg = Color(0xFF0F111E);
  static const Color cardBg = Color(0xFF171B2F);
  static const Color accentBlue = Color(0xFF2B66FF);
  static const Color textSecondary = Color(0xFF8E94A6);

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
    searchController.text = "chess"; // Cambiado a chess para que coincida con tu demo
    searchBooks();
  }

  Widget buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Buscador Estilizado como en la foto 2
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Buscar libros, autores...",
                hintStyle: const TextStyle(color: textSecondary),
                prefixIcon: const Icon(Icons.search, color: textSecondary),
                suffixIcon: searchController.text.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: textSecondary),
                        onPressed: () {
                          searchController.clear();
                          searchBooks();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onSubmitted: (_) => searchBooks(),
            ),
          ),
        ),

        // Título de la sección
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            "Resultados de búsqueda",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Lista de Libros Rediseñada
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: books.length,
            // SOLUCIÓN ERROR 2: Cambiado 'builder' por 'itemBuilder'
            itemBuilder: (context, index) {
              final book = books[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(
                        book: book,
                        onAddToCart: () {
                          setState(() {
                            cartItems.add(book);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${book.title} agregado al carrito'),
                              backgroundColor: accentBlue,
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Miniatura de Portada con Hero Animation
                      Hero(
  tag: 'book-cover-${book.id}', // Cambiado 'book.title' por 'book.id'
  child: ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: book.cover.isNotEmpty
        ? Image.network(book.cover, width: 60, height: 80, fit: BoxFit.cover)
        : Container(
            width: 60,
            height: 80,
            color: Colors.grey,
            child: const Icon(Icons.menu_book, color: Colors.white),
          ),
  ),
),
                      const SizedBox(width: 14),
                      
                      // Detalles del Texto (Título y Autor)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              book.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Botón 'Comprar' Modernizado
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            cartItems.add(book);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${book.title} agregado al carrito'),
                              backgroundColor: accentBlue,
                            ),
                          );
                        },
                        child: const Text(
                          'Comprar',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
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
      backgroundColor: scaffoldBg, // Fondo oscuro general
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        elevation: 0,
        title: const Text(
          'Librería Virtual',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: cardBg, // Fondo del menú inferior
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: accentBlue,
          unselectedItemColor: textSecondary,
          showUnselectedLabels: true,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Carrito',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Compras',
            ),
          ],
        ),
      ),
    );
  }
}