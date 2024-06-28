import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/widgets/product_card.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List products = <Product>[
    Product(productName: "Shaba", genericName: "null", category: "category", price: 21.0, productDescription: "description"),
    Product(productName: "Shabe", genericName: "null", category: "category", price: 19.0, productDescription: "description"),
  ];

  Widget cardTemplate(product){
    return ProductCard(product: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: products.map((product) => cardTemplate(product)).toList(),
        ),
      ),
    );
  }
}
