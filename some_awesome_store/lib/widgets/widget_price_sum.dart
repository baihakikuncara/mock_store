import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';

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
