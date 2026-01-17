import 'package:quickmart/models/product.dart';
import 'package:quickmart/models/search_filter.dart';
import 'package:dio/dio.dart';

// void main(List<String> args) {
//   test t = test();
//   t.searchProducts('as');
// }

// class test {
//   final dio = Dio();
//   final urlPath = "https://quickmart.codedbyyou.com/api";

//   Future<List<Product>> searchProducts(String searchQuery) async {
//     List<Product> searchedProducts = [];
//     try {
//       Response response = await dio.get("$urlPath/products/search?name=",
//           queryParameters: {"title": searchQuery});
//       var receivedAPIData = response.data as List<dynamic>;
     
//       searchedProducts
//           .addAll(receivedAPIData.map((e) => Product.fromJson(e)).toList());
//       print('PRODUCT SEARCH Success: ${response.data}');
//       print(searchedProducts.toString());
//     } catch (e) {
//       print('PRODUCT SEARCH Failed: $e');
//     }
//     return searchedProducts;
//   }
// }
