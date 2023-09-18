import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/widgets/tile_cart_product.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState {
  Future<bool> updateCartData() async {
    var cartItems = ref.read(cartNotifierProvider);
    var networkManager = ref.read(networkManagerProvider);
    List<(Product, int)> newData = [];

    for (final cartItem in cartItems) {
      var product = await networkManager.getProduct(cartItem.$1.id);
      if (product != null) {
        newData.add((product, cartItem.$2));
      }
    }
    ref.read(cartNotifierProvider.notifier).updateData(newData);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: FutureBuilder(
            future: updateCartData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var cart = ref.watch(cartNotifierProvider);
                if (cart.isEmpty) {
                  return const Center(child: Text('Cart is empty'));
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            for (final item in cart)
                              CartProductTile(item.$1, item.$2),
                          ],
                        ),
                      ),
                      const PriceSumWidget(),
                      const SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            onPressed: () {}, child: const Text('Purchase')),
                      ),
                    ],
                  );
                }
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
