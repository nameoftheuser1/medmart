import 'package:flutter/material.dart';
import 'package:medmart/screens/products/edit_product_screen.dart';
import 'package:medmart/services/product.dart';

class SelectedProduct extends StatelessWidget {
  final Product product;

  const SelectedProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.productName,
        style: const TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/blur.jpg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              color: Colors.black12,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Product Name:${product.productName}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                    ),
                    Text(
                      'Generic Name:${product.genericName}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Category: ${product.category}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Price: \$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      'Description: ${product.productDescription}',
                      style: const TextStyle( fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
