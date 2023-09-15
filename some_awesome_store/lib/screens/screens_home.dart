import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/screens/screen_cart.dart';
import 'package:some_awesome_store/widgets/badge_cart.dart';
import 'package:some_awesome_store/widgets/widget_products.dart';

final productsProvider = FutureProvider((ref) async {
  return await compute(getProducts, null);
});

Future<List> getProducts(_) async {
  var result = await dio.get('https://fakestoreapi.com/products');
  List<dynamic> data = result.data;
  List<Product> products = data.map((json) => Product.fromJson(json)).toList();
  return products;
}

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
