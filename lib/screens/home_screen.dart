import 'package:flutter/material.dart';
import 'package:medmart/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Padding(
        padding: EdgeInsets.all(9.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: [Text("Hello Mom")],),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
