import 'package:flutter/material.dart';
import 'package:medmart/services/sales_service.dart';
import 'package:medmart/widgets/sales_card.dart';

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
    _fetchSales();
  }

  Future<void> _fetchSales() async {
    setState(() {
      futureSales = widget.salesService.getAllSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchSales,
            tooltip: 'Refresh Sales Data',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchSales,
        child: FutureBuilder<List<Sales>>(
          future: futureSales,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No sales found', style: TextStyle(fontSize: 16, color: Colors.grey[600])));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final sales = snapshot.data![index];
                  return SalesCard(sales: sales);
                },
              );
            }
          },
        ),
      ),
    );
  }
}