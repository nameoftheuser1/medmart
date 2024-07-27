import 'package:flutter/material.dart';
import 'package:medmart/screens/sales/selected_sales.dart';
import 'package:medmart/services/saledetails_service.dart';
import 'package:medmart/services/sales_service.dart';

class SalesCard extends StatelessWidget {
  final Sales sales;

  SalesCard({required this.sales});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          'Sale ID: ${sales.id}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quantity: ${sales.quantity}',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 4),
              Text(
                'Sale Date: ${sales.saleDate.toLocal().toString().split(' ')[0]}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                'Total Amount: \$${sales.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectedSalesScreen(
                salesDetailsService: SalesDetailsService(baseUrl: 'http://10.0.2.2:8080'),
                salesId: sales.id,
              ),
            ),
          );
        },
      ),
    );
  }
}