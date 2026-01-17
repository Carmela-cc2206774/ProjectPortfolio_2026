import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quickmart/models/product.dart';

class SystemRepository {
  List<Product> products = [];
  Set<ProductCategory> categories = {};
  Future<List<Product>> loadProducts() async {
    // read the json file
    var jsonString = await rootBundle.loadString('assets/data/products.json');
    var jsonData = jsonDecode(jsonString);
    //print(jsonData);
    for (var p in jsonData) {
      products.add(Product.fromJson(p));
      //  print(products.first.title);
    }
    return products;
  }

  Future<Set<ProductCategory>> loadProductCategories() async {
    // read the json file
    var jsonString =
        await rootBundle.loadString('assets/data/product-categories.json');
    var jsonData = jsonDecode(jsonString);
    //print(jsonData);
    for (var c in jsonData) {
      categories.add(ProductCategory.fromJson(c));
      print(categories.last);
    }
    return categories;
  }
}
