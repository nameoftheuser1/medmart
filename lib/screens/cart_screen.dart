import 'package:flutter/material.dart';
import 'package:medmart/services/cart_service.dart';
import 'package:medmart/services/saledetails_service.dart';
import 'package:medmart/services/sales_service.dart';
import 'package:provider/provider.dart';
import 'package:medmart/screens/inventory_screen.dart';

class CartScreen extends StatelessWidget {
  final SalesDetailsService salesDetailsService;
  final SalesService salesService;

  const CartScreen({super.key, required
  this.salesDetailsService, required this.salesService});

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
              subtitle: Text(
                  'Price: \$${cartItem.product.price}\nQuantity: ${cartItem.quantity}'),
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
              onPressed: () async {
                // Calculate total quantity and amount
                int totalQuantity = cartService.items.fold(0, (sum, item) => sum + item.quantity);
                double totalAmount = cartService.totalAmount;

                // Create a new Sales record
                final newSale = Sales(
                  id: 0,
                  salesDetailsId: 0,
                  quantity: totalQuantity,
                  saleDate: DateTime.now(),
                  totalAmount: totalAmount,
                );

                try {
                  // Create the Sales record
                  await salesService.createSales(newSale);
                  print('Created sale: ${newSale.toJson()}');

                  // Create SalesDetails for each item
                  for (var item in cartService.items) {
                    try {
                      final salesDetails = SalesDetails(
                        id: 0,
                        productId: item.product.id,
                        quantity: item.quantity,
                        price: item.product.price,
                      );
                      await salesDetailsService.createSalesDetails(salesDetails);
                      print('Inserted: ${salesDetails.toJson()}');
                    } catch (e) {
                      print('Failed to insert item: ${item.product.id}. Error: $e');
                    }
                  }

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout successful!')),
                  );
                } catch (e) {
                  print('Failed to create sale. Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout failed. Please try again.')),
                  );
                }

                // Clear the cart and navigate back to the inventory screen
                cartService.clearCart();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InventoryScreen()),
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