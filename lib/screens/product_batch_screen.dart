import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/services/product_batch.dart';
import 'package:medmart/widgets/product_batch_card.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductBatchScreen extends StatefulWidget {
  const ProductBatchScreen({super.key});

  @override
  State<ProductBatchScreen> createState() => _ProductBatchScreenState();
}

class _ProductBatchScreenState extends State<ProductBatchScreen> {
  late Future<List<ProductBatch>> productBatches;

  Future<List<ProductBatch>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/batch/all'));

    final data = jsonDecode(response.body);

    List<ProductBatch> productBatches = [];

    for (var productBatch in data) {
      productBatches.add(ProductBatch.fromJson(productBatch));
    }
    return productBatches;
  }

  Future<void> _refreshData() async {
    setState(() {
      productBatches = fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    productBatches = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Product Batch"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<ProductBatch>>(
          future: productBatches,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No product batches found'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ProductBatchCard(productBatch: snapshot.data![index]);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewProductBatch()),
          );
        },
      ),
    );
  }
}

class NewProductBatch extends StatefulWidget {
  const NewProductBatch({super.key});

  @override
  State<NewProductBatch> createState() => _NewProductBatchState();
}

class _NewProductBatchState extends State<NewProductBatch> {
  final formKey = GlobalKey<FormState>();

  String batchNumber = '';
  DateTime expirationDate = DateTime.now();
  int quantity = 0;
  double supplierPrice = 0;
  int? selectedProductId;

  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/product/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        products = data.map((json) => Product.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final url = Uri.parse('http://10.0.2.2:8080/api/v1/batch/create');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'batchNumber': batchNumber,
          'productId': selectedProductId,
          'expirationDate': expirationDate.toIso8601String(),
          'quantity': quantity,
          'supplierPrice': supplierPrice,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product batch added successfully!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 64),
          ),
        );

        // Wait for the SnackBar to be displayed
        await Future.delayed(const Duration(seconds: 2));

        Navigator.pop(context); // Navigate back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add product batch.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Product Batch"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insert product batch details here.',
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
                      label: const Text("Batch Number"),
                      icon: const Icon(Icons.numbers),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a batch number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      batchNumber = value!;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      label: const Text("Product"),
                      icon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedProductId,
                    items: products.map((Product product) {
                      return DropdownMenuItem<int>(
                        value: product.id,
                        child: Text(product.productName),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedProductId = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a product';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: const Text("Expiration Date (YYYY-MM-DD)"),
                      icon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an expiration date';
                      }
                      if (DateTime.tryParse(value) == null) {
                        return 'Please enter a valid date in the format YYYY-MM-DD';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      expirationDate = DateTime.parse(value!);
                    },
                  ),
                  TextFormField(
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: const Text("Quantity"),
                      icon: const Icon(Icons.confirmation_number),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid quantity';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      quantity = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    maxLength: 40,
                    decoration: InputDecoration(
                      label: const Text("Supplier Price"),
                      icon: const Icon(Icons.price_check),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a supplier price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid price';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      supplierPrice = double.parse(value!);
                    },
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Add Product Batch"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}