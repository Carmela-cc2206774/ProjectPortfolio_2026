import 'package:dio/dio.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repo/product_repo.dart';

class FavoritesRepo {
  List<Product> favorites = [];

  final dio = Dio();
  final urlPath = "https://quickmart.codedbyyou.com/api";

  Future<List<Product>> loadFavorites() async {
    favorites = [];
    try {
      Response response = await dio.get("$urlPath/favorites");
      var receivedAPIData = response.data as List;
      for (Map<String, dynamic> p in receivedAPIData) {
        Product product = await ProductRepo().getProductById(p['productId']);
        favorites.add(product);
      }
      print('FAVORITES GET Success: ${response.statusCode}');
    } catch (e) {
      print('FAVORITES GET Failed: $e');
    }
    return favorites;
  }

  Future<bool> isFavorite(String id) async {
    try {
      Response response = await dio.get("$urlPath/favorites/$id");

      Product product =
          await ProductRepo().getProductById(response.data["productId"]);

      print('FAVORITES GET Success: ${response.statusCode}');
      return true;
    } catch (e) {
      print('FAVORITES GET Failed: $e');
      return false;
    }
  }

  Future<void> addToFavorites(String id) async {
    try {
      Response response =
          await dio.post("$urlPath/favorites", data: {"productId": id});

      print('FAVORITES POST Success: ${response.statusCode}');
    } catch (e) {
      print('FAVORITES POST Failed: $e');
    }
  }

  Future<void> deleteFromFavorites(String id) async {
    try {
      Response response = await dio.delete("$urlPath/favorites/$id");
      print('FAVORITES DELETE Success: ${response.statusCode}');
    } catch (e) {
      print('FAVORITES DELETE Failed: $e');
    }
  }

  Future<void> clearFavorites() async {
    try {
      late Response response;
      for (var product in favorites) {
        response = await dio.delete("$urlPath/favorites/$favorites.id");
      }
      print('FAVORITES DELETE Success: ${response.statusCode}');
    } catch (e) {
      print('FAVORITES DELETE Failed: $e');
    }
  }
}
