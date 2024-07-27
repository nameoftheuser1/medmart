import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/screens/products/selected_product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectedProduct(product: product),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    "(${product.genericName})",
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
              Text(product.category),
              Text("₱${product.price.toStringAsFixed(2)}"),
              Text(product.productDescription),
            ],
          ),
        ),
      ),
    );
  }
}