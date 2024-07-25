import 'package:medmart/services/product.dart';

class Bag {
  int bagId;
  Set<Product> products;
  int userId;
  int numberOfOrder;

  Bag({
    required this.bagId,
    required this.products,
    required this.userId,
    required this.numberOfOrder,
  });

  factory Bag.fromJson(Map<String, dynamic> json) {
    var productsJson = json['products'] as List<dynamic>;
    Set<Product> products = productsJson.map((productJson) {
      return Product.fromJson(productJson);
    }).toSet();

    return Bag(
      bagId: json['bagId'],
      products: products,
      userId: json['userId'],
      numberOfOrder: json['numberOfOrder'],
    );
  }

  Map<String, dynamic> toJson() => {
    'bagId': bagId,
    'products': products.map((product) => product.toJson()).toList(),
    'userId': userId,
    'numberOfOrder': numberOfOrder,
  };
}
