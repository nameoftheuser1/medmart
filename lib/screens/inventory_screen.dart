import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medmart/services/inventory.dart';
import 'package:medmart/services/product_batch.dart';
import 'package:medmart/widgets/inventory_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<Inventory>> inventoryItems;

  Future<List<Inventory>> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/inventory/all'));

    final data = jsonDecode(response.body);

    List<Inventory> inventoryItems = [];

    for (var item in data) {
      inventoryItems.add(Inventory.fromJson(item));
    }
    return inventoryItems;
  }

  Future<void> _refreshData() async {
    setState(() {
      inventoryItems = fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    inventoryItems = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Inventory"),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Inventory>>(
          future: inventoryItems,
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
                child: Text('No inventory items found'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InventoryCard(inventory: snapshot.data![index]);
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
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        productBatches = data.map((json) => ProductBatch.fromJson(json)).toList();
      });
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
