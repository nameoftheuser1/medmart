import 'package:flutter/foundation.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/services/cart_item.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product, int quantity) {
    final existingItem = _items.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.updateQuantity(existingItem.quantity + quantity);
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }

    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0, (total, item) => total + item.totalPrice);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
