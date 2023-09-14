import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:sqflite/sqflite.dart';

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    retrieveData();
  }

  void retrieveData() async {
    final db = await database;
    final List<Map<String, dynamic>> items = await db.query('cart');
    for (var item in items) {
      addItem(CartItem(item['id'], item['amount']), false);
    }
  }

  void addItem(CartItem newItem, [bool insertToDatabase = true]) {
    int amount = 0;
    for (final item in state) {
      if (item.id == newItem.id) {
        amount = item.amount;
        removeItem(item);
        break;
      }
    }
    CartItem tempItem = CartItem(newItem.id, newItem.amount + amount);
    state = [...state, tempItem];
    if (insertToDatabase) {
      addItemToDatabase(tempItem);
    }
  }

  void addItemToDatabase(CartItem item) async {
    final db = await database;
    db.insert(
      'cart',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void removeItem(CartItem newItem) {
    state = [
      for (final item in state)
        if (newItem.id != item.id) item
    ];
    removeItemFromDatabase(newItem.id);
  }

  void removeItemFromDatabase(int id) async {
    final db = await database;
    db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
    };
  }
}
