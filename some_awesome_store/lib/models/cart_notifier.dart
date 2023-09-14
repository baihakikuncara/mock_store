import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(CartItem newItem) {
    int amount = 0;
    for (final item in state) {
      if (item.id == newItem.id) {
        amount = item.amount;
        removeItem(item);
        break;
      }
    }
    state = [...state, CartItem(newItem.id, newItem.amount + amount)];
  }

  void removeItem(CartItem newItem) {
    state = [
      for (final item in state)
        if (newItem.id != item.id) item
    ];
  }
}

class CartItem {
  final int id;
  final int amount;

  const CartItem(this.id, this.amount);

  @override
  String toString() {
    return '$id:$amount';
  }
}
