class ProductBatch {
  final String batchNumber;
  final DateTime expirationDate;
  final int quantity;
  final double supplierPrice;

  ProductBatch({
    required this.batchNumber,
    required this.expirationDate,
    required this.quantity,
    required this.supplierPrice,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    try {
      return ProductBatch(
        batchNumber: json['batchNumber'],
        expirationDate: DateTime.parse(json['expirationDate']),
        quantity: json['quantity'],
        supplierPrice: json['supplierPrice'].toDouble(),
      );
    } catch (e) {
      throw FormatException('Failed to parse product batch data: $e');
    }
  }
}
