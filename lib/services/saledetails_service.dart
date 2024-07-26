import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesDetailsService {
  final String baseUrl;

  SalesDetailsService({required this.baseUrl});

  Future<List<SalesDetails>> getAllSalesDetails() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/salesdetails/all'));

      if (response.statusCode == 200) {
        List<dynamic> salesDetailsJson = json.decode(response.body);
        return salesDetailsJson.map((json) => SalesDetails.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sales details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching sales details: $e');
    }
  }

  Future<SalesDetails> getSalesDetailsById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/salesdetails/$id'));

      if (response.statusCode == 200) {
        return SalesDetails.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load sales details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching sales details by ID: $e');
    }
  }

  Future<List<SalesDetails>> getSalesDetailsBySalesId(int salesId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/v1/salesdetails/by-sales-id?salesId=$salesId'));

      if (response.statusCode == 200) {
        List<dynamic> salesDetailsJson = json.decode(response.body);
        return salesDetailsJson.map((json) => SalesDetails.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sales details by salesId: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching sales details by salesId: $e');
    }
  }

  Future<void> createSalesDetails(SalesDetails salesDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/salesdetails/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(salesDetails.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create sales details: ${response.body}');
      }
    } catch (e) {
      print('Error creating sales details: $e');
      throw Exception('Error creating sales details: $e');
    }
  }

  Future<void> updateSalesDetails(int id, SalesDetails salesDetails) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/v1/salesdetails/edit/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(salesDetails.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update sales details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating sales details: $e');
    }
  }

  Future<void> deleteSalesDetails(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/v1/salesdetails/delete/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete sales details: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting sales details: $e');
    }
  }
}

class SalesDetails {
  final int id;
  final int salesId;
  final int productId;
  final int quantity;
  final double price;

  SalesDetails({
    required this.id,
    required this.salesId,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory SalesDetails.fromJson(Map<String, dynamic> json) {
    return SalesDetails(
      id: json['id'],
      salesId: json['salesId'],
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salesId': salesId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}