import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  final String baseUrl;

  DashboardService({required this.baseUrl});

  Future<int> getTotalProductCount() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/dashboard/totalProductCount'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total product count');
    }
  }

  Future<int> getTotalInventoryCount() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/dashboard/totalInventoryCount'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total inventory count');
    }
  }

  Future<int> getTotalProductBatchesCount() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/dashboard/totalProductBatchesCount'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total product batches count');
    }
  }

  Future<int> getTotalSalesCount() async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/dashboard/totalSalesCount'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load total sales count');
    }
  }

  Future<int> getSalesPerDay(String date) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/dashboard/salesPerDay?date=$date'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load sales per day');
    }
  }

  Future<int> getSalesPerWeek(String startDate) async {
    final response = await http.get(Uri.parse('$baseUrl/api/v1/dashboard/salesPerWeek?startDate=$startDate'));
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Failed to load sales per week');
    }
  }
}
