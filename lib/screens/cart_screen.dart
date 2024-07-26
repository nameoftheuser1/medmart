import 'package:flutter/material.dart';
import 'package:medmart/services/cart_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: cartService.items.isEmpty
          ? const Center(
        child: Text('Your cart is empty'),
      )
          : ListView.builder(
        itemCount: cartService.items.length,
        itemBuilder: (context, index) {
          final cartItem = cartService.items[index];

          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(cartItem.product.productName),
              subtitle: Text('Price: \$${cartItem.product.price}\nQuantity: ${cartItem.quantity}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  cartService.removeFromCart(cartItem.product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product removed from cart'),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \$${cartService.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checkout functionality not implemented'),
                  ),
                );
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
