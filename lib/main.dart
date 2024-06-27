import 'package:flutter/material.dart';
import 'package:medmart/screens/home_screen.dart';
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
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/product': (context) => const ProductScreen(),
        });
  }
}
