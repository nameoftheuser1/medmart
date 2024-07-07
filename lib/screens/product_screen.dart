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
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/products'));

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
        title: Text("Products"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/newproduct');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
            // children: products.map((product) => cardTemplate(product)).toList(),
            ),
      ),
    );
  }
}

class newProduct extends StatefulWidget {
  const newProduct({super.key});

  @override
  State<newProduct> createState() => _newProductState();
}

class _newProductState extends State<newProduct> {
  final formKey = GlobalKey<FormState>();

  String productName = '';
  String genericName = '';
  String category = '';
  String productDescription = '';
  double price = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add products"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Insert product details here.',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 16,),
            Form(child: Column(
              children: [
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                    label: Text("Product Name"),
                    icon: Icon(Icons.add),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                      helperText: "Optional",
                      label: Text("Generic Name"),
                      icon: Icon(Icons.medication),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                      label: Text("Category"),
                      icon: Icon(Icons.medication),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                      label: Text("Product Description"),
                      icon: Icon(Icons.medication),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(
                      label: Text("Price"),
                      icon: Icon(Icons.medication),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
                ElevatedButton(onPressed: (){}, child: Text("Add Product"))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
