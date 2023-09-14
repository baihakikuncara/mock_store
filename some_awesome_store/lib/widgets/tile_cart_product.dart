import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';

class CartProductTile extends ConsumerWidget {
  final CartItem cartItem;

  const CartProductTile(this.cartItem, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const SizedBox.square(
          dimension: 50,
          child: Placeholder(),
        ),
        Expanded(
          flex: 1,
          child: Text('${cartItem.id}'),
        ),
        Text('${cartItem.amount}'),
        IconButton(
          onPressed: () {
            var cart = ref.read(cartNotifierProvider.notifier);
            cart.removeItem(cartItem);
          },
          icon: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
