import 'package:flutter/material.dart';
import 'package:some_awesome_store/screens/screen_cart.dart';
import 'package:some_awesome_store/widgets/badge_cart.dart';
import 'package:some_awesome_store/widgets/widget_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: const ProductsWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ));
        },
        child: const CartBadgeIcon(),
      ),
    );
  }
}
