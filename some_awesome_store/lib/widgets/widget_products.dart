import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'tile_product.dart';

class ProductsWidget extends ConsumerWidget {
  const ProductsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var products = ref.watch(productsProvider);
    return products.when(
      data: (data) {
        print(data);
        if (data.isEmpty) {
          return const Center(
            child: Text('No products to show'),
          );
        } else {
          return GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
            childAspectRatio: 3 / 4,
            children: data.map((e) => ProductTile(e)).toList(),
          );
        }
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Center(
        child: Text('Failed to load products'),
      ),
    );
  }
}
