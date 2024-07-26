import 'package:medmart/services/product.dart';

class Bag {
  int bagId;
  Set<Product> products;
  int userId;
  int numberOfOrder;

  Bag({
    required this.bagId,
    required this.userId,
    required this.numberOfOrder,
    required this.products,
  });

  factory Bag.fromJson(Map<String, dynamic> json) {
    var productsFromJson = json['products'] as List;
    Set<Product> productSet = productsFromJson.map((product) => Product.fromJson(product)).toSet();

    return Bag(
      bagId: json['bagId'],
      userId: json['userId'],
      numberOfOrder: json['numberOfOrder'],
      products: productSet,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bagId': bagId,
      'userId': userId,
      'numberOfOrder': numberOfOrder,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
