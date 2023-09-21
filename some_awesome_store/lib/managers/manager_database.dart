import 'dart:io' show Platform;
import 'package:path/path.dart';
import 'package:some_awesome_store/models/products.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseManager {
  static const databaseName = 'cart_database.db';
  static const createDBQuery =
      'CREATE TABLE cart(id INTEGER PRIMARY KEY, title TEXT, price REAL, description TEXT, category TEXT, image TEXT, amount INT)';

  static Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }
    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    if (Platform.isWindows) {
      return databaseFactory.openDatabase(
          join(await getDatabasesPath(), 'cart_database.db'),
          options: OpenDatabaseOptions(
            onCreate: (db, version) {
              return db.execute(createDBQuery);
            },
            version: 1,
          ));
    }
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(createDBQuery);
      },
      version: 1,
    );
  }

  Future<List<(Product, int)>> retrieveCartData() async {
    var db = await getDatabase();
    List<(Product, int)> cartData = [];
    final List<Map<String, dynamic>> result = await db.query('cart');
    for (final data in result) {
      cartData.add((Product.fromJson(data), data['amount'] as int));
    }
    return cartData;
  }

  void addItem(Product item, int amount) async {
    var db = await getDatabase();
    var data = item.toMap();
    data['amount'] = amount;
    db.insert(
      'cart',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void removeItem(int id) async {
    var db = await getDatabase();
    db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void closeDatabase() async {
    var db = await getDatabase();
    db.close();
  }
}
