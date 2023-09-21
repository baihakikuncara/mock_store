import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:some_awesome_store/managers/manager_database.dart';
import 'package:some_awesome_store/managers/manager_network.dart';
import 'package:some_awesome_store/models/cart_notifier.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:some_awesome_store/screens/screens_home.dart';

enum Category {
  all,
  electronics,
  jewelry,
  menClothing,
  womenClothing,
}

final networkManagerProvider = StateProvider((ref) => NetworkManager());
final databaseManagerProvider = StateProvider((ref) => DatabaseManager());
final cartNotifierProvider =
    StateNotifierProvider<CartNotifier, List<(Product, int)>>(
        (ref) => CartNotifier(ref.read(databaseManagerProvider)));
final categoryProvider = StateProvider((ref) => Category.all);
final productsProvider = FutureProvider((ref) async {
  final response = await ref.watch(networkManagerProvider).getAllProducts();
  var category = ref.watch(categoryProvider);
  var categoryString = '';
  switch (category) {
    case Category.electronics:
      categoryString = 'electronics';
      break;
    case Category.jewelry:
      categoryString = 'jewelry';
      break;
    case Category.menClothing:
      categoryString = "men's clothing";
      break;
    case Category.womenClothing:
      categoryString = "women's clothing";
      break;
    default:
      break;
  }
  switch (category) {
    case Category.all:
      return response;
    default:
      return response.where((element) => element.category == categoryString);
  }
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    ref.read(networkManagerProvider);
    ref.read(databaseManagerProvider);
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
