class ProductBatch {
  final int productBatchId;
  final String batchNumber;
  final int productId;
  final DateTime expirationDate;
  final int quantity;
  final double supplierPrice;

  ProductBatch({
    required this.productBatchId,
    required this.batchNumber,
    required this.productId,
    required this.expirationDate,
    required this.quantity,
    required this.supplierPrice,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    try {
      return ProductBatch(
        productBatchId: json['productBatchId'],
        batchNumber: json['batchNumber'],
        productId: json['productId'],
        expirationDate: DateTime.parse(json['expirationDate']),
        quantity: json['quantity'],
        supplierPrice: json['supplierPrice'].toDouble(),
      );
    } catch (e) {
      throw FormatException('Failed to parse product batch data: $e');
    }
  }
}
