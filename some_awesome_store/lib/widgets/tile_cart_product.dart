import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';

class CartProductTile extends ConsumerStatefulWidget {
  final CartItem cartItem;

  const CartProductTile(this.cartItem, {super.key});

  @override
  ConsumerState<CartProductTile> createState() => _CartProductTileState();
}

class _CartProductTileState extends ConsumerState<CartProductTile> {
  late final Future<Product> product;

  @override
  void initState() {
    super.initState();
    product = getProduct();
  }

  Future<Product> getProduct() async {
    var result = await dio
        .get('https://fakestoreapi.com/products/${widget.cartItem.id}');
    return Product.fromJson(result.data);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
      child: FutureBuilder(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Row(
              children: [
                SizedBox.square(
                  dimension: 50,
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('\$${snapshot.data!.price}'),
                    ],
                  ),
                ),
                Text('${widget.cartItem.amount}'),
                const Text('='),
                SizedBox(
                    width: 40,
                    child: Text(
                      '${snapshot.data!.price * widget.cartItem.amount}',
                      textAlign: TextAlign.end,
                    )),
                IconButton(
                  onPressed: () {
                    var cart = ref.read(cartNotifierProvider.notifier);
                    cart.removeItem(widget.cartItem);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('failed to get data'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
