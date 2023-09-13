import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/screens/screens_home.dart';
import 'tile_product.dart';

class ProductsWidget extends ConsumerWidget {
  const ProductsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.watch(productsProvider);
    return provider.when(
      data: (data) {
        return GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
          children: data.map((e) => ProductTile(e)).toList(),
        );
      },
      error: (error, stackTrace) => const Center(
        child: Text('error'),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
