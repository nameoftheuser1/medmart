class Inventory {
  int productBatchId;
  int quantity;

  Inventory({required this.productBatchId, required this.quantity});

  factory Inventory.fromJson(Map<String, dynamic> json) {
    try {
      return Inventory(
          productBatchId: json['productBatchId'], quantity: json['quantity']);
    } catch (e) {
      throw FormatException('Failed to parse inventory data: $e');
    }
  }
}
