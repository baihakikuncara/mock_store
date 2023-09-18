import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/products.dart';
import 'tile_product.dart';

class ProductsWidget extends ConsumerWidget {
  const ProductsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(networkManagerProvider);
    return FutureBuilder(
      future: provider.getAllProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = snapshot.data!;
          if (products.isEmpty) {
            return const Center(
              child: Text('Failed to load products'),
            );
          } else {
            return GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
              childAspectRatio: 3 / 4,
              children: products.map((e) => ProductTile(e)).toList(),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(child: Text('error'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
