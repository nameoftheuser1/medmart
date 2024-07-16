import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> _inventoryItems = [
    {"name": "Liquid", "quantity": 10, "image": Icons.inventory},
    {"name": "Tablet", "quantity": 8, "image": Icons.inventory},
    {"name": "Capsule", "quantity": 8, "image": Icons.inventory},
    {"name": "Cream", "quantity": 8, "image": Icons.inventory},
    {"name": "Ointment", "quantity": 8, "image": Icons.inventory},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality here
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _inventoryItems.length,
        itemBuilder: (context, index) {
          final item = _inventoryItems[index];
          return Card(
            child: ListTile(
              leading: Icon(item['image']),
              title: Text(item['name']),
              subtitle: Text('Quantity: ${item['quantity']}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  // Implement edit functionality here
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Implement add functionality here
        },
      ),
    );
  }
}
