import 'package:medmart/services/inventory.dart';

class ProductBatch {
  final int productBatchId;
  final String batchNumber;
  final int productId;
  final DateTime expirationDate;
  final int quantity;
  final double supplierPrice;
  final Inventory? inventory;

  ProductBatch({
    required this.productBatchId,
    required this.batchNumber,
    required this.productId,
    required this.expirationDate,
    required this.quantity,
    required this.supplierPrice,
    this.inventory,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    return ProductBatch(
      productBatchId: json['productBatchId'],
      batchNumber: json['batchNumber'],
      productId: json['productId'],
      expirationDate: DateTime.parse(json['expirationDate']),
      quantity: json['quantity'],
      supplierPrice: json['supplierPrice'],
      inventory: json['inventory'] != null
          ? Inventory.fromJson(json['inventory'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'productBatchId': productBatchId,
    'batchNumber': batchNumber,
    'productId': productId,
    'expirationDate': expirationDate.toIso8601String(),
    'quantity': quantity,
    'supplierPrice': supplierPrice,
    'inventory': inventory?.toJson(),
  };
}
