import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.productName,
                  style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                ),
                SizedBox(width: 10.0,),
                Text(
                  "(${product.genericName})",
                  style: TextStyle(color: Colors.black45),
                ),
              ],),
            Text(
              product.category,
            ),
            Text(
                "${product.price}"
            ),
            Text(
                product.productDescription
            )
          ],

        ),
      ),
    );
  }
}
