import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/widgets/tile_cart_product.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState {
  Future<List<(Product, int)>> updateData() async {
    await ref.read(cartNotifierProvider.notifier).updateData();
    return ref.watch(cartNotifierProvider);
  }

  @override
  Widget build(BuildContext context) {
    List<(Product, int)> carts = ref.watch(cartNotifierProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: carts.isEmpty
            ? const Center(
                child: Text('Cart is empty'),
              )
            : FutureBuilder(
                future: updateData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        for (final item in carts)
                          CartProductTile(item.$1, item.$2),
                        const PriceSumWidget(),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('error'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }));
  }
}

class PriceSumWidget extends ConsumerWidget {
  const PriceSumWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cart = ref.watch(cartNotifierProvider);
    var sum = 0.0;
    for (final item in cart) {
      sum += item.$1.price * item.$2;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Total ='),
          SizedBox(
            width: 86,
            child: Text(
              '\$${sum.toStringAsFixed(2)}',
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(
            width: 57,
          ),
        ],
      ),
    );
  }
}
