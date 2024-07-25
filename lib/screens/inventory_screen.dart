import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medmart/services/inventory.dart';
import 'package:medmart/services/product_batch.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/widgets/inventory_card.dart';
import 'package:medmart/screens/cart_screen.dart'; // Import the CartScreen

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Inventory>> inventoryItems;
  late Future<List<Product>> products;

  Future<List<Inventory>> fetchInventoryData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/inventory/all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<Inventory>((item) => Inventory.fromJson(item)).toList();
      } else {
        throw Exception('Invalid JSON format for inventory data');
      }
    } else {
      throw Exception('Failed to load inventory data');
    }
  }

  Future<List<Product>> fetchProductData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/product/all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data.map<Product>((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Invalid JSON format for product data');
      }
    } else {
      throw Exception('Failed to load product data');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      inventoryItems = fetchInventoryData();
      products = fetchProductData();
    });
  }

  @override
  void initState() {
    super.initState();
    inventoryItems = fetchInventoryData();
    products = fetchProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Inventory>>(
          future: inventoryItems,
          builder: (context, inventorySnapshot) {
            if (inventorySnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitFadingCircle(
                  color: Colors.blue,
                  size: 50.0,
                ),
              );
            } else if (inventorySnapshot.hasError) {
              return Center(
                child: Text('Error: ${inventorySnapshot.error}'),
              );
            } else if (!inventorySnapshot.hasData || inventorySnapshot.data!.isEmpty) {
              return const Center(
                child: Text('No inventory items found'),
              );
            } else {
              return FutureBuilder<List<Product>>(
                future: products,
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitFadingCircle(
                        color: Colors.blue,
                        size: 50.0,
                      ),
                    );
                  } else if (productSnapshot.hasError) {
                    return Center(
                      child: Text('Error: ${productSnapshot.error}'),
                    );
                  } else if (!productSnapshot.hasData || productSnapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: inventorySnapshot.data!.length,
                      itemBuilder: (context, index) {
                        final inventory = inventorySnapshot.data![index];
                        final product = productSnapshot.data!.firstWhere(
                              (p) => p.id == inventory.productBatchId,
                          orElse: () => Product(
                            id: inventory.productBatchId,
                            productName: 'Unknown',
                            genericName: 'Unknown',
                            category: 'Unknown',
                            productDescription: 'Unknown',
                            price: 0.0,
                            imageUrl: '',
                          ),
                        );
                        return InventoryCard(
                          inventory: inventory,
                          product: product,
                        );
                      },
                    );
                  }
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
            MaterialPageRoute(builder: (context) => const NewInventoryItem()),
          );
        },
      ),
    );
  }
}

class NewInventoryItem extends StatefulWidget {
  const NewInventoryItem({super.key});

  @override
  State<NewInventoryItem> createState() => _NewInventoryItemState();
}

class _NewInventoryItemState extends State<NewInventoryItem> {
  final formKey = GlobalKey<FormState>();

  int quantity = 0;
  int? selectedProductBatchId;

  List<ProductBatch> productBatches = [];

  @override
  void initState() {
    super.initState();
    fetchProductBatches();
  }

  Future<void> fetchProductBatches() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/batch/all'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        setState(() {
          productBatches = data.map((json) => ProductBatch.fromJson(json)).toList();
        });
      } else {
        throw Exception('Invalid JSON format for product batches');
      }
    } else {
      throw Exception('Failed to load product batches');
    }
  }

  Future<void> _submitForm() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final url = Uri.parse('http://10.0.2.2:8080/api/v1/inventory/create');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productBatchId': selectedProductBatchId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inventory item added successfully!'),
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
          const SnackBar(content: Text('Failed to add inventory item.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Inventory Item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Insert inventory item details here.',
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
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      label: const Text("Product Batch"),
                      icon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: selectedProductBatchId,
                    items: productBatches.map((ProductBatch productBatch) {
                      return DropdownMenuItem<int>(
                        value: productBatch.productBatchId,
                        child: Text(productBatch.batchNumber),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedProductBatchId = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a product batch';
                      }
                      return null;
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
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Add Inventory Item"),
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
