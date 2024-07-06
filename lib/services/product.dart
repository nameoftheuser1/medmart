class Product {
  String productName;
  String genericName;
  String category;
  String productDescription;
  double price;

  Product({
    required this.productName,
    required this.genericName,
    required this.category,
    required this.productDescription,
    required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'],
      genericName: json['genericName'],
      category: json['category'],
      price: json['price'].toDouble(),
      productDescription: json['productDescription'],
    );
  }
}