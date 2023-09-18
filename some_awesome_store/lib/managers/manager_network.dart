import 'package:dio/dio.dart';
import 'package:some_awesome_store/models/products.dart';

class NetworkManager {
  late final Dio dio;

  NetworkManager() {
    dio = Dio();
  }

  Future<List<Product>> getAllProducts() async {
    try {
      var result = await dio.get('https://fakestoreapi.com/products/');
      List<dynamic> data = result.data;
      return data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      return List.empty();
    }
  }

  Future<Product?> getProduct(int id) async {
    try {
      var result = await dio.get('https://fakestoreapi.com/products/$id');
      return Product.fromJson(result.data);
    } catch (e) {
      return null;
    }
  }
}
