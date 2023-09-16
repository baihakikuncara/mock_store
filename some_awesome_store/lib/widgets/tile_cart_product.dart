import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/screens/screen_product_detail.dart';

class CartProductTile extends ConsumerStatefulWidget {
  final Product product;
  final int amount;

  const CartProductTile(this.product, this.amount, {super.key});

  @override
  ConsumerState<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends ConsumerState<CartProductTile> {
  late final Future<Product> updatedProductData;

  @override
  void initState() {
    super.initState();
    updatedProductData = getProduct();
  }

  Future<Product> getProduct() async {
    var result =
        await dio.get('https://fakestoreapi.com/products/${widget.product.id}');
    return Product.fromJson(result.data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: FutureBuilder(
        future: updatedProductData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Tile(snapshot.data!, widget.amount, false);
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('failed to get data'),
            );
          } else {
            return Tile(widget.product, widget.amount, true);
          }
        },
      ),
    );
  }
}

class Tile extends ConsumerWidget {
  static const thumbnailSize = 50.0;
  static const fieldSizeSmall = 30.0;
  static const fieldSizeMed = 50.0;
  static const fieldSizeWide = 75.0;

  final Product product;
  final int amount;
  final bool temp;

  const Tile(this.product, this.amount, this.temp, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var price = temp
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: fieldSizeMed,
                child: Text(
                  '\$${product.price}',
                  textAlign: TextAlign.end,
                )),
          );
    var totalPrice = temp
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: fieldSizeWide,
              child: Text(
                '\$${product.price * amount}',
                textAlign: TextAlign.end,
              ),
            ),
          );
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product),
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox.square(
              dimension: thumbnailSize,
              child: CachedNetworkImage(
                imageUrl: product.image,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: fieldSizeSmall,
            child: Text(
              '$amount',
              textAlign: TextAlign.end,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'x',
            ),
          ),
          price,
          const Text('='),
          totalPrice,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                var cart = ref.read(cartNotifierProvider.notifier);
                cart.removeItem(product);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
