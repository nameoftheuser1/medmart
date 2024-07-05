import 'package:flutter/material.dart';

class ProductBatchScreen extends StatefulWidget {
  const ProductBatchScreen({super.key});

  @override
  State<ProductBatchScreen> createState() => _ProductBatchScreenState();
}

class _ProductBatchScreenState extends State<ProductBatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Batch"),
      ),
    );
  }
}
