import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'tile_product.dart';

class ProductsWidget extends ConsumerWidget {
  const ProductsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var products = ref.watch(productsProvider);
    var selected = ref.watch(categoryProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Category: '),
              DropdownMenu(
                onSelected: (value) {
                  ref.read(categoryProvider.notifier).state = value!;
                },
                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                    value: Category.all,
                    label: 'All Categories',
                  ),
                  DropdownMenuEntry(
                    value: Category.electronics,
                    label: 'Electronics',
                  ),
                  DropdownMenuEntry(
                    value: Category.jewelry,
                    label: 'Jewelery',
                  ),
                  DropdownMenuEntry(
                    value: Category.menClothing,
                    label: "Men's Clothing",
                  ),
                  DropdownMenuEntry(
                    value: Category.womenClothing,
                    label: "Women's Clothing",
                  ),
                ],
                initialSelection: selected,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: products.when(
            data: (data) {
              if (data!.isEmpty) {
                return const Center(
                  child: Text('No products to show'),
                );
              } else {
                return GridView.count(
                  crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
                  childAspectRatio: 3 / 4,
                  children: data.map((e) => ProductTile(e)).toList(),
                );
              }
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => const Center(
              child: Text('Failed to load products'),
            ),
          ),
        )
      ],
    );
  }
}
