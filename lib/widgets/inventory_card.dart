import 'package:flutter/material.dart';
import 'package:medmart/services/inventory.dart';

class InventoryCard extends StatelessWidget {
  final Inventory inventory;

  const InventoryCard({Key? key, required this.inventory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.inventory),
        title: Text('Batch ID: ${inventory.productBatchId}'),
        subtitle: Text('Quantity: ${inventory.quantity}'),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Implement edit functionality here
          },
        ),
      ),
    );
  }
}
