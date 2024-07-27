import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medmart/screens/inventory/new_inventory.dart';
import 'package:medmart/services/inventory.dart';
import 'package:medmart/services/product.dart';
import 'package:medmart/services/sales_service.dart';
import 'package:medmart/widgets/inventory_card.dart';
import 'package:medmart/screens/cart_screen.dart';
import 'package:medmart/services/saledetails_service.dart';

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
    final String baseUrl = 'http://10.0.2.2:8080';
    final SalesDetailsService salesDetailsService = SalesDetailsService(baseUrl: baseUrl);


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
                MaterialPageRoute(builder: (context) => CartScreen(
                  salesDetailsService: salesDetailsService,
                  salesService: SalesService(baseUrl: baseUrl),
                  inventoryService: InventoryService(baseUrl: baseUrl),
                )),
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

