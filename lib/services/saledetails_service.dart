import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class SalesDetailsService {
  final String baseUrl;

  SalesDetailsService({required this.baseUrl});

  Future<List<SalesDetails>> getAllSalesDetails() async {
    final response = await http.get(Uri.parse('$baseUrl/salesDetails'));

    if (response.statusCode == 200) {
      List<dynamic> salesDetailsJson = json.decode(response.body);
      return salesDetailsJson.map((json) => SalesDetails.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sales details');
    }
  }

  Future<SalesDetails> getSalesDetailsById(Long id) async {
    final response = await http.get(Uri.parse('$baseUrl/salesDetails/$id'));

    if (response.statusCode == 200) {
      return SalesDetails.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sales details');
    }
  }

  Future<void> createSalesDetails(SalesDetails salesDetails) async {
    final response = await http.post(
      Uri.parse('$baseUrl/salesDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(salesDetails.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create sales details');
    }
  }

  Future<void> updateSalesDetails(Long id, SalesDetails salesDetails) async {
    final response = await http.put(
      Uri.parse('$baseUrl/salesDetails/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(salesDetails.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sales details');
    }
  }

  Future<void> deleteSalesDetails(Long id) async {
    final response = await http.delete(Uri.parse('$baseUrl/salesDetails/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete sales details');
    }
  }
}

class SalesDetails {
  final Long id;
  final Long productId;
  final int quantity;
  final double price;

  SalesDetails({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory SalesDetails.fromJson(Map<String, dynamic> json) {
    return SalesDetails(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
