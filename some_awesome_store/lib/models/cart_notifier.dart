import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/main.dart';
import 'package:some_awesome_store/managers/manager_database.dart';
import 'package:some_awesome_store/models/products.dart';

class CartNotifier extends StateNotifier<List<(Product, int)>> {
  CartNotifier(DatabaseManager databaseManager) : super([]) {
    initializeData(databaseManager);
  }

  Future<void> initializeData(DatabaseManager databaseManager) async {
    state = await databaseManager.retrieveCartData();
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

  void addItem(Product newItem, int amount, WidgetRef ref) {
    var databaseManager = ref.read(databaseManagerProvider);
    if (amount == 0) {
      removeItem(newItem.id, ref);
      return;
    }
    for (final item in state) {
      if (item.$1.id == newItem.id) {
        removeItem(item.$1.id, ref);
        break;
      }
    }
    state = [...state, (newItem, amount)];

    databaseManager.addItem(newItem, amount);
  }

  void removeItem(int id, WidgetRef ref) {
    var databaseManager = ref.read(databaseManagerProvider);
    state = [
      for (final item in state)
        if (id != item.$1.id) item
    ];

    databaseManager.removeItem(id);
  }
}
