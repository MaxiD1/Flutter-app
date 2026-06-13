import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/purchase_service.dart';

class CartScreen extends StatelessWidget {
  final List<Book> cartItems;
  final PurchaseService purchaseService;
  final VoidCallback onClearCart;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.purchaseService,
    required this.onClearCart,
  });

  Future<void> buyAll(BuildContext context) async {
    if (cartItems.isEmpty) return;

    try {
      for (final book in cartItems) {
        await purchaseService.buyBook(
          bookId: book.id,
          title: book.title,
          author: book.author,
        );
      }

      onClearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra realizada con éxito'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error en la compra: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(
        child: Text(
          'El carrito está vacío',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final book = cartItems[index];

              return ListTile(
                leading: book.cover.isNotEmpty
                    ? Image.network(book.cover, width: 50)
                    : const Icon(Icons.menu_book),

                title: Text(book.title),
                subtitle: Text(book.author),
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => buyAll(context),
              child: const Text('Comprar todo'),
            ),
          ),
        ),
      ],
    );
  }
}