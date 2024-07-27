import 'package:flutter/material.dart';
import 'package:medmart/services/sales_service.dart';

class SalesScreen extends StatefulWidget {
  final SalesService salesService;

  SalesScreen({required this.salesService});

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late Future<List<Sales>> futureSales;

  @override
  void initState() {
    super.initState();
    futureSales = widget.salesService.getAllSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Details'),
      ),
      body: FutureBuilder<List<Sales>>(
        future: futureSales,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No sales found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final sales = snapshot.data![index];
                return ListTile(
                  title: Text('Sale ID: ${sales.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity: ${sales.quantity}'),
                      Text('Sale Date: ${sales.saleDate.toLocal().toString().split(' ')[0]}'),
                      Text('Total Amount: \$${sales.totalAmount}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
