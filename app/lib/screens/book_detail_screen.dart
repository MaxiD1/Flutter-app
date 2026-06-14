import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart'; // Importamos el servicio para la descripción

class BookDetailScreen extends StatefulWidget {
  final Book book;
  final VoidCallback onAddToCart;

  const BookDetailScreen({
    super.key,
    required this.book,
    required this.onAddToCart,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _bookService = BookService();
  late Future<String> _descriptionFuture;

  @override
  void initState() {
    super.initState();
    // Disparamos la petición a la API al cargar la pantalla
    _descriptionFuture = _bookService.getBookDescription(widget.book.id);
  }

  String formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;

    for (int i = priceStr.length - 1; i >= 0; i--) {
      result = priceStr[i] + result;
      count++;
      if (count == 3 && i != 0) {
        result = '.$result';
        count = 0;
      }
    }
    return '\$$result';
  }

  @override
  Widget build(BuildContext context) {
    const primaryDark = Color(0xFF121624);
    const accentBlue = Color(0xFF2B66FF);
    const textSecondary = Color(0xFF8E94A6);

    return Scaffold(
      backgroundColor: primaryDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Detalle del Libro', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Portada animada con ID Único
              Center(
                child: Hero(
                  tag: 'book-cover-${widget.book.id}', // Match perfecto con el ID de home_screen
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: widget.book.cover.isNotEmpty
                          ? Image.network(widget.book.cover, fit: BoxFit.cover)
                          : const Icon(Icons.menu_book, size: 100, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              
              // Título y Autor
              Text(
                widget.book.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Por ${widget.book.author}',
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 15),
              
              // Precio
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formatPrice(widget.book.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              
              // Sección Sinopsis con FutureBuilder para datos de API en vivo
              const Text(
                'Sinopsis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              
              FutureBuilder<String>(
                future: _descriptionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator(color: accentBlue)),
                    );
                  }
                  
                  // Si la API trajo una descripción real, la usamos. Si no, usamos el fallback dinámico
                  final apiDescription = snapshot.data;
                  final displayDescription = (apiDescription != null && apiDescription.isNotEmpty)
                      ? apiDescription
                      : 'Disfruta de "${widget.book.title}", una obra imprescindible escrita por ${widget.book.author}. Esta entrega ofrece una propuesta literaria fascinante que captura la esencia de su género. Explora sus capítulos y descubre por qué se ha convertido en una pieza clave para lectores de todo el mundo.';

                  return Text(
                    displayDescription,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              
              // Botonera de Compra
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    widget.onAddToCart();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Agregar al Carrito',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}