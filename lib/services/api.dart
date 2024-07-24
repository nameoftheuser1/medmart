import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medmart/services/product.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api/v1/product';

  static Future<bool> updateProduct(Product product) async {
    final response = await http.put(
      Uri.parse('$baseUrl/edit/${product.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'productName': product.productName,
        'genericName': product.genericName,
        'category': product.category,
        'productDescription': product.productDescription,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );

    return response.statusCode == 200;
  }
}
