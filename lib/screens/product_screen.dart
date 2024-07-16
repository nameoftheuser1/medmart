import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/widgets/product_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<dynamic>> products;

  Future<List<dynamic>> fetchData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/product/all'));

    final data = jsonDecode(response.body);

    List products = <Product>[];

    for (var product in data) {
      products.add(Product.fromJson(product));
    }
    return products;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    products = fetchData();
  }

  // List products = <Product>[
  //   Product(productName: "practice", genericName: "null", category: "category", price: 21.0, productDescription: "description"),
  //   Product(productName: "practice_1", genericName: "null", category: "category", price: 19.0, productDescription: "description"),
  // ];

  // Widget cardTemplate(product){
  //   return ProductCard(product: product);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/newproduct');
        },
      ),
    );
  }
}

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final formKey = GlobalKey<FormState>();

  String productName = '';
  String genericName = '';
  String category = '';
  String productDescription = '';
  double price = 0;

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final url = Uri.parse('http://10.0.2.2:8080/api/v1/product/create');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productName': productName,
          'genericName': genericName,
          'category': category,
          'productDescription': productDescription,
          'price': price,
          'imageUrl': "assets/placeholderimg.jpg",
        }),
      );

      if (response.statusCode == 200) {
        // Successfully added product
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')));
      } else {
        // Failed to add product
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add product.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insert product details here.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 40,
                      decoration: InputDecoration(
                          label: const Text("Product Name"),
                          icon: const Icon(Icons.add),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        productName = value!;
                      },
                    ),
                    TextFormField(
                      maxLength: 40,
                      decoration: InputDecoration(
                          helperText: "Optional",
                          label: const Text("Generic Name"),
                          icon: const Icon(Icons.medication),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onSaved: (value) {
                        genericName = value!;
                      },
                    ),
                    TextFormField(
                      maxLength: 40,
                      decoration: InputDecoration(
                          label: const Text("Category"),
                          icon: const Icon(Icons.category),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        category = value!;
                      },
                    ),
                    TextFormField(
                      maxLength: 40,
                      decoration: InputDecoration(
                          label: const Text("Product Description"),
                          icon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a product description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        productDescription = value!;
                      },
                    ),
                    TextFormField(
                      maxLength: 40,
                      decoration: InputDecoration(
                          label: const Text("Price"),
                          icon: const Icon(Icons.price_check),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        price = double.parse(value!);
                      },
                    ),
                    ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text("Add Product"))
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
