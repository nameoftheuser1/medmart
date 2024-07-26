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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/blur.jpg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  product.productName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Generic Name: ${product.genericName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                Text(
                  'Category: ${product.category}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                Text(
                  'Description: ${product.productDescription}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
                SizedBox(height: 0.0),
                Text(
                  'Price: \$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
