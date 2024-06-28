import 'package:flutter/material.dart';
import 'package:medmart/screens/dashboard_screen.dart';
import 'package:medmart/screens/product_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 56, 150, 81),
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
        scaffoldBackgroundColor: Colors.white70,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // backgroundColor: Colors.blueGrey,
          // selectedItemColor: Colors.white,
          // unselectedItemColor: Colors.grey,
          selectedIconTheme: IconThemeData(size: 30),
          unselectedIconTheme: IconThemeData(size: 25),
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
        cardTheme: CardTheme(color: Colors.white38,)
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Remove the const keyword
  final List<Widget> _widgetOptions = [
    DashboardScreen(),
    ProductScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Products',
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.inventory),
          //     label: 'Inventory',
          // ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person),
          //     label: 'Profile',
          // )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
