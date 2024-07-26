import 'package:medmart/services/product_batch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final String baseUrl;

  ProductService(this.baseUrl);

  Future<Product> getProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/product/$id'));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }
}

class Product {
  final int id;
  final String productName;
  final String genericName;
  final String category;
  final String productDescription;
  final double price;
  final String imageUrl;
  final ProductBatch? productBatch;

  Product({
    required this.id,
    required this.productName,
    required this.genericName,
    required this.category,
    required this.productDescription,
    required this.price,
    required this.imageUrl,
    this.productBatch,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['productName'],
      genericName: json['genericName'],
      category: json['category'],
      productDescription: json['productDescription'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      productBatch: json['productBatch'] != null
          ? ProductBatch.fromJson(json['productBatch'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productName': productName,
    'genericName': genericName,
    'category': category,
    'productDescription': productDescription,
    'price': price,
    'imageUrl': imageUrl,
    'productBatch': productBatch?.toJson(),
  };
}