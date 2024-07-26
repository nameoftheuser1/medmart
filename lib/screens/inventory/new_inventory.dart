import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medmart/services/product_batch.dart';

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
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      quantity = int.parse(value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
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
