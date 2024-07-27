import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medmart/services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService dashboardService = DashboardService(baseUrl: 'http://10.0.2.2:8080');
  int totalProductCount = 0;
  int totalInventoryCount = 0;
  int totalProductBatchesCount = 0;
  int totalSalesCount = 0;
  double salesPerDay = 0.0;
  double salesPerWeek = 0.0;

  final numberFormat = NumberFormat.decimalPattern();

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
      String startOfWeekDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: now.weekday - 1)));

      final totalProductCount = await dashboardService.getTotalProductCount();
      final totalInventoryCount = await dashboardService.getTotalInventoryCount();
      final totalProductBatchesCount = await dashboardService.getTotalProductBatchesCount();
      final totalSalesCount = await dashboardService.getTotalSalesCount();
      final salesPerDay = await dashboardService.getSalesPerDay(formattedDate);
      final salesPerWeek = await dashboardService.getSalesPerWeek(startOfWeekDate);

      setState(() {
        this.totalProductCount = totalProductCount;
        this.totalInventoryCount = totalInventoryCount;
        this.totalProductBatchesCount = totalProductBatchesCount;
        this.totalSalesCount = totalSalesCount;
        this.salesPerDay = salesPerDay;
        this.salesPerWeek = salesPerWeek;
      });
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }
  }

  Future<void> _refreshData() async {
    await fetchDashboardData();
  }

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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/hh.jpg'),
              fit: BoxFit.cover
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildDashboardCard(
                        title: "Total Products",
                        value: numberFormat.format(totalProductCount),
                        icon: Icons.inventory,
                        color: Colors.blue,
                      ),
                      _buildDashboardCard(
                        title: "Total Inventory",
                        value: numberFormat.format(totalInventoryCount),
                        icon: Icons.store,
                        color: Colors.green,
                      ),
                      _buildDashboardCard(
                        title: "Total Product Batches",
                        value: numberFormat.format(totalProductBatchesCount),
                        icon: Icons.batch_prediction,
                        color: Colors.orange,
                      ),
                      _buildDashboardCard(
                        title: "Total Sales",
                        value: numberFormat.format(totalSalesCount),
                        icon: Icons.attach_money,
                        color: Colors.red,
                      ),
                      _buildDashboardCard(
                        title: "Sales Per Day",
                        value: numberFormat.format(salesPerDay),
                        icon: Icons.today,
                        color: Colors.purple,
                      ),
                      _buildDashboardCard(
                        title: "Sales Per Week",
                        value: numberFormat.format(salesPerWeek),
                        icon: Icons.calendar_view_week,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black54),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
