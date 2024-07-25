import 'package:flutter/material.dart';
import 'package:medmart/services/inventory.dart';
import 'package:medmart/services/product.dart';
import 'package:provider/provider.dart';
import 'package:medmart/services/cart_service.dart';

class InventoryCard extends StatelessWidget {
  final Inventory inventory;
  final Product product;

  const InventoryCard({
    Key? key,
    required this.inventory,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: const Icon(Icons.inventory),
        title: Text(product.productName),
        subtitle: Text('Quantity: ${inventory.quantity}'),
        trailing: inventory.quantity > 0
            ? IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            final cartService = Provider.of<CartService>(context, listen: false);
            cartService.addToCart(product, inventory.quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product added to cart'),
              ),
            );
          },
        )
            : const Text('Out of stock'),
      ),
    );
  }
}
