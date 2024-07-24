import 'package:flutter/material.dart';
import 'package:medmart/screens/products/edit_product_screen.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/services/api.dart';

class SelectedProduct extends StatelessWidget {
  final Product product;

  const SelectedProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductScreen(product: product),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.productName,
            ),
            SizedBox(height: 8.0),
            Text('Generic Name: ${product.genericName}'),
            Text('Category: ${product.category}'),
            Text('Description: ${product.productDescription}'),
            SizedBox(height: 8.0),
            Text('Price: \$${product.price.toStringAsFixed(2)}'),
            // Add more widgets if necessary to display additional product details
          ],
        ),
      ),
    );
  }
}
