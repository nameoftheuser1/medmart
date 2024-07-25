import 'package:medmart/services/product_batch.dart';

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
