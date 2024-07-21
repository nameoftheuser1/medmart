class ProductBatch {
  int id;
  int batchNumber;
  DateTime expirationDate;
  int quantity;
  double supplierPrice;

  ProductBatch({
    required this.id,
    required this.batchNumber,
    required this.expirationDate,
    required this.quantity,
    required this.supplierPrice,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    return switch (json) {
    {
      'id': int id,
      'batchNumber': int batchNumber,
      'expirationDate': DateTime expirationDate,
      'quantity': int quantity,
      'supplierPrice': double supplierPrice,
    } =>
    ProductBatch(
      id: id,
      batchNumber: batchNumber,
      expirationDate: expirationDate,
      quantity: quantity,
      supplierPrice: supplierPrice),
      _ => throw const FormatException('Failed to load products')
    };
  }
}

