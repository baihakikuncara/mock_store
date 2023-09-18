import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:sqflite/sqflite.dart';

final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<(Product, int)>>(
        (ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<(Product, int)>> {
  CartNotifier() : super([]) {
    retrieveData();
  }

  void retrieveData() async {
    final db = await database;
    final List<Map<String, dynamic>> items = await db.query('cart');
    for (var item in items) {
      addItem(Product.fromJson(item), item['amount'], false);
    }
  }

  void updateData(List<(Product, int)> updatedData) {
    state = updatedData;
  }

  bool contains(Product product) {
    for (final item in state) {
      if (item.$1.id == product.id) {
        return true;
      }
    }
    return false;
  }

  int getAmount(Product product) {
    for (final item in state) {
      if (item.$1.id == product.id) return item.$2;
    }
    return 0;
  }

  void addItem(Product newItem, int amount, [bool insertToDatabase = true]) {
    if (amount == 0) {
      removeItem(newItem);
      return;
    }
    for (final item in state) {
      if (item.$1.id == newItem.id) {
        removeItem(item.$1);
        break;
      }
    }
    state = [...state, (newItem, amount)];
    if (insertToDatabase) {
      addItemToDatabase(newItem, amount);
    }
  }

  void addItemToDatabase(Product item, int amount) async {
    final db = await database;
    var data = item.toMap();
    data['amount'] = amount;
    db.insert(
      'cart',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void removeItem(Product newItem) {
    state = [
      for (final item in state)
        if (newItem.id != item.$1.id) item
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
