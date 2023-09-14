import 'package:flutter/material.dart';
import 'package:some_awesome_store/models/products.dart';

enum Size {
  small,
  medium,
  large,
}

class StarRatingWidget extends StatelessWidget {
  final Rating rating;
  final Size size;

  const StarRatingWidget(this.rating, this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    var starsIcons = [
      for (var i = 1; i <= 5; i++)
        Icon(
          i < rating.rate
              ? Icons.star
              : i > rating.rate.floor() && i < rating.rate.ceil()
                  ? Icons.star_half
                  : Icons.star_border,
          size: size == Size.small
              ? 15
              : size == Size.medium
                  ? 20
                  : 30,
        )
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: starsIcons,
        ),
        Text('${rating.rate}'),
        Text('(${rating.count})'),
      ],
    );
  }
}
