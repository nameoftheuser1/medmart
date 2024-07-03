import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int outOfStock = 56;
  double totalSupplier = 900.00;
  int nearlyExpired = 2302396;
  int onlineOrders = 1245;
  int todaysReport = 762;

  final numberFormat = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DASHBOARD",
          style: TextStyle(
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: .0,),
            Center(
              child: Image.asset(
                'assets/removebg.png',
                width: 300,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildDashboardCard(
                    title: "Out of Stock",
                    value: numberFormat.format(outOfStock),
                    icon: Icons.warning,
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    title: "Total Supplier",
                    value: numberFormat.format(totalSupplier),
                    icon: Icons.local_shipping,
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    title: "Nearly Expired",
                    value: numberFormat.format(nearlyExpired),
                    icon: Icons.explicit,
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    title: "Online Orders",
                    value: numberFormat.format(onlineOrders),
                    icon: Icons.shopping_cart,
                    color: Colors.green,
                  ),
                  _buildDashboardCard(
                    title: "Today's Report",
                    value: numberFormat.format(todaysReport),
                    icon: Icons.report,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black12),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
