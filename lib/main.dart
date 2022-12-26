import 'package:flutter/material.dart';
import 'package:myshop_flutter_application/screens/cart_screen.dart';
import 'package:myshop_flutter_application/screens/orders_screen.dart';
import 'package:myshop_flutter_application/screens/product_details_screen.dart';
import 'package:myshop_flutter_application/screens/products_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(primarySwatch: Colors.purple),
      routes: {
        '/': (context) => const ProductsScreen(),
        OrdersScreen.routeName: (context) => const OrdersScreen(),
        ProductDetailsScreen.routeName: (context) =>
            const ProductDetailsScreen(),
        CartScreen.routeName: (context) => const CartScreen(),
      },
    );
  }
}