import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';

class CartBadgeIcon extends ConsumerWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cart = ref.watch(cartNotifierProvider);
    var cartIcon = const Icon(Icons.shopping_cart);

    return cart.isEmpty
        ? cartIcon
        : Badge(
            label: null,
            child: cartIcon,
          );
  }
}
