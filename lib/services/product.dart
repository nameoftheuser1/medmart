class Product {
  int id;
  String productName;
  String genericName;
  String category;
  String productDescription;
  double price;
  String imageUrl;

  Product(
      {required this.id,
        required this.productName,
        required this.genericName,
        required this.category,
        required this.productDescription,
        required this.price,
        required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'id': int id,
      'productName': String productName,
      'genericName': String genericName,
      'category': String category,
      'productDescription': String productDescription,
      'price': double price,
      'imageUrl' : String imageUrl
      } =>
          Product(
              id: id,
              productName: productName,
              genericName: genericName,
              category: category,
              productDescription: productDescription,
              price: price,
              imageUrl: imageUrl),
      _ => throw const FormatException('Failed to load products')
    };
  }
}