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
    var controller = ref.read(searchBarControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Search...',
          ),
          onEditingComplete: () {
            var value = controller.text;
            ref.watch(searchBarValueProvider.notifier).state = value;
          },
        ),
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
