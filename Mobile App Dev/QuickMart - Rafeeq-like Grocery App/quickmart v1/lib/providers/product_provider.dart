import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/models/search_filter.dart';
import 'package:quickmart/repo/product_repo.dart';

class ProductProvider extends Notifier<List<Product>> {
  final ProductRepo productRepo = ProductRepo();
  List<Product> products = [];

  ProductProvider() : super();

  @override
  List<Product> build() {
    _loadProducts();
    return [];
  }

  Future<void> _loadProducts() async {
    state = await productRepo.loadProducts();
    products = state;
  }

  Future<Product> getProductById(String id) {
    Future<Product> product = productRepo.getProductById(id);

    return product;
  }

  //List<Product> getProducts() => products;

  void filterProducts(SearchFilters filters) async {
    state = await productRepo.filterProducts(filters);
  }
}

final productProviderNotifier =
    NotifierProvider<ProductProvider, List<Product>>(() => ProductProvider());
