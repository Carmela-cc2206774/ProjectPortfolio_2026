import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repos/system_repository.dart';

class ProductProvider extends Notifier<List<Product>> {
  List<Product> products = [];

  final SystemRepository _systemRepository = SystemRepository();
  @override
  List<Product> build() {
    initializeProducts();
    return [];
  }

  void initializeProducts() async {
    products = await _systemRepository.loadProducts();
    state = products;
  }


  void updateProductState(String query) {
    // ignore: unnecessary_null_comparison
    state = (query == '') ? products : filterProducts(query);
  }

  void updateProductStateFromCategories(Set<String> categoriesToFilter) {
    // ignore: unnecessary_null_comparison
    state = (categoriesToFilter.isEmpty)
        ? products
        : filterProductsFromCategories(categoriesToFilter.toList());
  }

  List<Product> filterProducts(String query) {
    return products
        .where((products) =>
            products.getTitle.toLowerCase().contains(query.toLowerCase()) ||
            products.getCategory.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Product> filterProductsFromCategories(List<String> list) {
    List<Product> filteredProducts = [];

    for (String category in list) {
      List<Product> productsForCategory = products
          .where((products) =>
              products.getCategory.toLowerCase().contains(category.toLowerCase()))
          .toList();
      filteredProducts.addAll(productsForCategory);
    }
    return filteredProducts;
  }


}

final productNotifierProvider =
    NotifierProvider<ProductProvider, List<Product>>(() => ProductProvider());
