import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/screens/screen_product_detail.dart';
import 'package:some_awesome_store/widgets/widget_star_rating.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetailScreen(product)),
        ),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StarRatingWidget(product.rating, Size.small),
                    Text(
                      textAlign: TextAlign.start,
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      textAlign: TextAlign.start,
                      '\$${product.price}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
