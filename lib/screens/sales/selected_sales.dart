import 'package:flutter/material.dart';
import 'package:medmart/services/saledetails_service.dart';

class SelectedSalesScreen extends StatefulWidget {
  final SalesDetailsService salesDetailsService;
  final int salesId;

  SelectedSalesScreen({
    required this.salesDetailsService,
    required this.salesId,
  });

  @override
  _SelectedSalesScreenState createState() => _SelectedSalesScreenState();
}

class _SelectedSalesScreenState extends State<SelectedSalesScreen> {
  late Future<List<SalesDetails>> futureSalesDetails;

  @override
  void initState() {
    super.initState();
    futureSalesDetails = widget.salesDetailsService.getSalesDetailsBySalesId(widget.salesId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Details'),
      ),
      body: FutureBuilder<List<SalesDetails>>(
        future: futureSalesDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No details found'));
          } else {
            final salesDetailsList = snapshot.data!;
            return ListView.builder(
              itemCount: salesDetailsList.length,
              itemBuilder: (context, index) {
                final salesDetails = salesDetailsList[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sales ID: ${salesDetails.salesId}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Product ID: ${salesDetails.productId}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Quantity: ${salesDetails.quantity}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Price: \$${salesDetails.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
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
