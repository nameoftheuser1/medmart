import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class SalesService {
  final String baseUrl;

  SalesService({required this.baseUrl});

  Future<List<Sales>> getAllSales() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/sales'));

    if (response.statusCode == 200) {
      List<dynamic> salesJson = json.decode(response.body);
      return salesJson.map((json) => Sales.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<Sales> getSalesById(Long id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/sales/$id'));

    if (response.statusCode == 200) {
      return Sales.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load sales');
    }
  }

  Future<void> createSales(Sales sales) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/sales/create'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(sales.toJson()),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Failed to create sales. Status code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      print('Error in createSales: $e');
      throw e;
    }
  }

  Future<void> updateSales(Long id, Sales sales) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/v1/sales/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(sales.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sales');
    }
  }

  Future<void> deleteSales(Long id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/v1/sales/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete sales');
    }
  }
}

class Sales {
  final int id;
  final int salesDetailsId;
  final int quantity;
  final DateTime saleDate;
  final double totalAmount;

  Sales({
    required this.id,
    required this.salesDetailsId,
    required this.quantity,
    required this.saleDate,
    required this.totalAmount,
  });

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      id: json['id'],
      salesDetailsId: json['salesDetailsId'],
      quantity: json['quantity'],
      saleDate: DateTime.parse(json['saleDate']),
      totalAmount: json['totalAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salesDetailsId': salesDetailsId,
      'quantity': quantity,
      'saleDate': saleDate.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }
}
