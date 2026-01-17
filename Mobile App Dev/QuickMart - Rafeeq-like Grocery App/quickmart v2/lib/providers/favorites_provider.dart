import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';

final favoritesNotifierProvider =
    NotifierProvider<FavoritesProvider, Map<Product, bool>>(
        () => FavoritesProvider());

class FavoritesProvider extends Notifier<Map<Product, bool>> {
  //Set<Product> favorites = {};
  Map<Product, bool> isFavorite = {};

  @override
  Map<Product, bool> build() {
    initializeFaves();
    return {};
  }

  void initializeFaves() async {
    state = isFavorite;
  }

  void addToFaves(Product product) {
    state = {
      ...state,
      product: true,
    };
  }

  void removeFromeFaves(Product product) {
    state = {
      ...state,
      product: false,
    };
  }

  List<Product> favesToCart() {
    List<Product> moveToCart = [];
    state.forEach((product, isFave) => moveToCart.add(product));
    state = {};
    return moveToCart;
  }
}
