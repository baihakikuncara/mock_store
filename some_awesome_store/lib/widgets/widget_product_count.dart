import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:some_awesome_store/models/products.dart';

class ProductCountWidget extends StatefulWidget {
  static const iconSize = 20.0;

  final Product product;

  const ProductCountWidget(this.product, {super.key});

  @override
  State<ProductCountWidget> createState() => _ProductCountWidgetState();
}

class _ProductCountWidgetState extends State<ProductCountWidget> {
  final TextEditingController countController =
      TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton.filled(
          iconSize: ProductCountWidget.iconSize,
          onPressed: () {
            setState(() {
              var val = int.parse(countController.text);
              countController.text = max(0, val - 1).toString();
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
          ),
        ),
        IconButton.filled(
          iconSize: ProductCountWidget.iconSize,
          onPressed: () {
            setState(() {
              var val = int.parse(countController.text);
              countController.text = min(999, val + 1).toString();
            });
          },
          icon: const Icon(Icons.add),
        ),
        ElevatedButton.icon(
          onPressed: countController.text == '0' ? null : () {},
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Add to cart'),
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
