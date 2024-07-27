import 'dart:convert';

import 'package:http/http.dart' as http;

class InventoryService {
  final String baseUrl;

  InventoryService({required this.baseUrl});

  Future<Inventory> fetchInventoryByProductBatchId(int productBatchId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/inventory/byProduct/$productBatchId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Inventory.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch inventory');
    }
  }

  Future<void> updateInventoryQuantity(int inventoryId, int quantity) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/inventory/updateQuantity/$inventoryId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(quantity),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update inventory quantity');
    }
  }
}


class Inventory {
  final int id;
  final int productBatchId;
  final int quantity;

  Inventory({
    required this.id,
    required this.productBatchId,
    required this.quantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      productBatchId: json['productBatchId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productBatchId': productBatchId,
    'quantity': quantity,
  };
}
