import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class CategoryRepository {
  List<String> categories = [];
  final dio = Dio();
  final urlPath = "https://quickmart.codedbyyou.com/api";

  Future<List<String>> fetchCategories() async {
    try {
      Response response = await dio.get("$urlPath/categories");
      var receivedAPIData = response.data as List;
      receivedAPIData.forEach((cat) => categories.add(cat));
      print('CATEGORY GET Success: ${response.statusCode}');
    } catch (e) {
      print('CATEGORY GET Failed: $e');
    }
    return categories;
  }
}
