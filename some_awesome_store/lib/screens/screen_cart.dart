import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/widgets/tile_cart_product.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<(Product, int)> carts = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: carts.isEmpty
          ? const Center(
              child: Text('Cart is empty'),
            )
          : ListView(
              children: [
                for (final item in carts) CartProductTile(item.$1, item.$2)
              ],
            ),
    );
  }
}
