import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/screens/screen_cart.dart';
import 'package:some_awesome_store/widgets/badge_cart.dart';
import 'package:some_awesome_store/widgets/widget_products.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedCategory = ref.watch(categoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            initialValue: selectedCategory,
            itemBuilder: (context) {
              return const <PopupMenuEntry<Category>>[
                PopupMenuItem(
                  value: Category.all,
                  child: Text('All Categories'),
                ),
                PopupMenuItem(
                  value: Category.electronics,
                  child: Text('Electronics'),
                ),
                PopupMenuItem(
                  value: Category.jewelry,
                  child: Text('Jewelry'),
                ),
                PopupMenuItem(
                  value: Category.menClothing,
                  child: Text("Men's Clothing"),
                ),
                PopupMenuItem(
                  value: Category.womenClothing,
                  child: Text("Women's Clothing"),
                ),
              ];
            },
            onSelected: (value) {
              ref.read(categoryProvider.notifier).state = value;
              print(ref.read(categoryProvider));
            },
          ),
        ],
      ),
      body: const ProductsWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CartScreen(),
              ));
        },
        child: const CartBadgeIcon(),
      ),
    );
  }
}
