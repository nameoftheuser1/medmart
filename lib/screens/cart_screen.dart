import 'package:flutter/material.dart';
import 'package:medmart/services/cart_service.dart';
import 'package:medmart/services/saledetails_service.dart';
import 'package:medmart/services/sales_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  final SalesDetailsService salesDetailsService;
  final SalesService salesService;

  const CartScreen({super.key, required this.salesDetailsService, required this.salesService});

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
                int totalQuantity = cartService.items.fold(0, (sum, item) => sum + item.quantity);
                double totalAmount = cartService.totalAmount;

                final newSale = Sales(
                  id: 0,
                  quantity: totalQuantity,
                  saleDate: DateTime.now(),
                  totalAmount: totalAmount,
                );

                try {
                  final createdSale = await salesService.createSales(newSale);
                  print('Created sale: ${createdSale.toJson()}');

                  List<Future<void>> salesDetailsFutures = [];

                  for (var item in cartService.items) {
                    final salesDetails = SalesDetails(
                      id: 0,
                      salesId: createdSale.id,
                      productId: item.product.id,
                      quantity: item.quantity,
                      price: item.product.price,
                    );

                    print('Creating SalesDetails: ${salesDetails.toJson()}');
                    salesDetailsFutures.add(salesDetailsService.createSalesDetails(salesDetails));
                  }

                  await Future.wait(salesDetailsFutures);
                  print('All sales details created successfully.');

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout successful!')),
                  );

                  cartService.clearCart();
                  Navigator.pop(context);
                } catch (e) {
                  print('Checkout failed. Error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout failed. Please try again.')),
                  );
                }
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}