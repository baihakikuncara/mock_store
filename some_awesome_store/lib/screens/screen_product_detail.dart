import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:some_awesome_store/models/products.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen(this.product, {super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    var rating = product.rating.rate.round();
    for (int i = 1; i <= 5; i++) {
      if (i < product.rating.rate) {
        stars.add(const Icon(Icons.star));
      } else if (i > product.rating.rate && i <= rating) {
        stars.add(const Icon(Icons.star_half));
      } else {
        stars.add(const Icon(Icons.star_border));
      }
    }
    var windowSize = MediaQuery.of(context).size;
    var imageSize = min(windowSize.width / 2, windowSize.height / 2);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox.square(
              dimension: imageSize,
              child: CachedNetworkImage(imageUrl: product.image),
            ),
            Text(product.title),
            Text('\$${product.price}'),
            Row(
              children: stars,
            ),
            Row(
              children: [
                Text('${product.rating.count} vote(s)'),
                Text('${product.rating.rate} rating'),
              ],
            ),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
