import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart'; // Import Product class
import 'package:medmart/services/product_batch.dart';
import 'package:intl/intl.dart';

class ProductBatchCard extends StatelessWidget {
  final Product product;
  final ProductBatch productBatch;

  const ProductBatchCard({
    required this.product,
    required this.productBatch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDate = formatter.format(productBatch.expirationDate);

    return Card(
      child: ListTile(
        title: Text(product.productName),
        subtitle: Text('Batch Number: ${productBatch.batchNumber}\nExpires on: ${formattedDate}'),
        trailing: Text('Qty: ${productBatch.quantity}'),
      ),
    );
  }
}
