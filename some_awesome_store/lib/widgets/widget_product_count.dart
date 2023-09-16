import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';

class ProductCountWidget extends ConsumerStatefulWidget {
  static const iconSize = 20.0;

  final Product product;

  const ProductCountWidget(this.product, {super.key});

  @override
  ConsumerState<ProductCountWidget> createState() => _ProductCountWidgetState();
}

class _ProductCountWidgetState extends ConsumerState<ProductCountWidget> {
  final TextEditingController countController =
      TextEditingController(text: '0');

  int amount = -1;

  @override
  Widget build(BuildContext context) {
    var cart = ref.watch(cartNotifierProvider);

    if (amount < 0) {
      amount = cart
          .firstWhere(
            (element) => element.$1.id == widget.product.id,
            orElse: () => (widget.product, 0),
          )
          .$2;
      countController.text = '$amount';
    }

    var inCart =
        cart.where((element) => element.$1.id == widget.product.id).isNotEmpty;
    var label =
        inCart ? const Text('Change amount') : const Text('Add to cart');

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton.filled(
              iconSize: ProductCountWidget.iconSize,
              onPressed: () {
                setState(() {
                  amount = max(amount - 1, 0);
                  countController.text = '$amount';
                });
              },
              icon: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 30,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: countController,
                onChanged: (value) {
                  amount = int.parse(countController.text);
                },
              ),
            ),
            IconButton.filled(
              iconSize: ProductCountWidget.iconSize,
              onPressed: () {
                setState(() {
                  amount = min(amount + 1, 999);
                  countController.text = '$amount';
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: countController.text == '0' && !inCart
              ? null
              : () {
                  var cartNotifier = ref.watch(cartNotifierProvider.notifier);
                  cartNotifier.addItem(
                      widget.product, int.parse(countController.text));
                },
          icon: const Icon(Icons.shopping_cart),
          label: label,
        ),
      ],
    );
  }

  @override
  void dispose() {
    countController.dispose();
    super.dispose();
  }
}
