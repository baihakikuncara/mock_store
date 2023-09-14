import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/widgets/widget_star_rating.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen(this.product, {super.key});
  @override
  Widget build(BuildContext context) {
    var windowSize = MediaQuery.of(context).size;
    var imageSize = min(windowSize.width / 2, windowSize.height / 2);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox.square(
                dimension: 16,
              ),
              Row(
                children: [
                  SizedBox.square(
                    dimension: imageSize,
                    child: CachedNetworkImage(imageUrl: product.image),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      StarRatingWidget(product.rating, Size.medium),
                      const SizedBox.square(
                        dimension: 16,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('Add to cart'),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox.square(
                dimension: 32,
              ),
              const Text('Description:'),
              const SizedBox.square(
                dimension: 16,
              ),
              Text(product.description),
            ],
          ),
        ),
      ),
    );
  }
}
