import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/widgets/tile_cart_product.dart';
import 'package:some_awesome_store/widgets/widget_price_sum.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
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
    Future(
      () {
        ref.watch(cartNotifierProvider.notifier).updateData(newData);
      },
    );

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
            return cart.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : Column(
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
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error retrieving cart data'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
