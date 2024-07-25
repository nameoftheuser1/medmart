class Inventory {
  final int id;
  final int productBatchId;
  final int quantity;

  Inventory({
    required this.id,
    required this.productBatchId,
    required this.quantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      productBatchId: json['productBatchId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productBatchId': productBatchId,
    'quantity': quantity,
  };
}
