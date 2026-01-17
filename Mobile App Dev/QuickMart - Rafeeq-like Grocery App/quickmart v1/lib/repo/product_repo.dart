import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/models/search_filter.dart';
import 'package:dio/dio.dart';

class ProductRepo {
  bool _loaded = false;
  final Logger _logger = Logger('ProductRepo');
  bool loaded = false;
  List<Product> _products = [];

  final dio = Dio();
  final urlPath = "https://quickmart.codedbyyou.com/api";

  Future<List<Product>> loadProducts() async {
    try {
      Response response = await dio.get("$urlPath/products");
      var receivedAPIData = response.data as List;
      _products
          .addAll(receivedAPIData.map((e) => Product.fromJson(e)).toList());
      _loaded = true;
      _logger.info("Products loaded: ${_products.length}");
      print('PRODUCTS GET Success: ${response.statusCode}');
    } catch (e) {
      print('PRODUCTS GET Failed: $e');
    }
    return _products;
  }

  Future<Product> getProductById(String id) async {
    var receivedAPIData;
    try {
      Response response = await dio.get("$urlPath/products/$id");
      receivedAPIData = response.data as Map<String, dynamic>;
      print('PRODUCT GET Success: ${response.data}');
    } catch (e) {
      print('PRODUCT GET Failed: $e');
    }
    return Product.fromJson(receivedAPIData);
  }

  Future<List<Product>> filterProducts(SearchFilters filters) async {
    final queryParameters = {
      if (filters.searchText.isNotEmpty) 'name': filters.searchText,
      if (filters.categories.isNotEmpty)
        'category': filters.categories.join(','),
      if (filters.minPrice != 0) 'minPrice': filters.minPrice,
      if (filters.maxPrice != 0) 'maxPrice': filters.maxPrice,
    };

    List<Product> filteredProducts = [];
    try {
      Response response = await dio.get("$urlPath/products/search",
          queryParameters: queryParameters);
      var receivedAPIData = response.data as List<dynamic>;
      filteredProducts
          .addAll(receivedAPIData.map((e) => Product.fromJson(e)).toList());
      print('PRODUCT SEARCH Success: ${response.data}');
      print(filteredProducts.toString());
    } catch (e) {
      print('PRODUCT SEARCH Failed: $e');
    }
    return filteredProducts;
  }

  // Future<List<Product>> searchProducts(String searchQuery) async {
  //   List<Product> searchedProducts = [];
  //   try {
  //     Response response = await dio.get("$urlPath/products/search?name=",
  //         queryParameters: {"title": searchQuery});
  //     var receivedAPIData = response.data as List<Map<String, dynamic>>;
  //     searchedProducts
  //         .addAll(receivedAPIData.map((e) => Product.fromJson(e)).toList());
  //     print('PRODUCT SEARCH Success: ${response.data}');
  //     print(searchedProducts.toString());
  //   } catch (e) {
  //     print('PRODUCT SEARCH Failed: $e');
  //   }
  //   return searchedProducts;
  // }
}

final productRepo = ProductRepo();
