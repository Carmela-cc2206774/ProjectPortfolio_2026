import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repo/favorites_repo.dart';

/// A provider that manages the favorite products
/// The only reason i am dealing with the favorite this way is because
/// i am not using a database to store the favorite products or a repository
/// to manage the favorite products, else i would have used a repository to manage the favorite products
class FavoriteProvider extends AsyncNotifier<List<Product>> {
  final FavoritesRepo favoritesRepo = FavoritesRepo();
  @override
  Future<List<Product>> build() async {
    getFavoriteProducts();
    return [];
  }

  void getFavoriteProducts() async {
    state = AsyncData(await favoritesRepo.loadFavorites());
  }

  Future<bool> toggleFavorite(Product product) async {
    AsyncData<bool> isToggle = AsyncData(await isProductFavorite(product.id));
    if (isToggle.value) {
      favoritesRepo.deleteFromFavorites(product.id);
      state = AsyncData(await favoritesRepo.loadFavorites());
    } else {
      favoritesRepo.addToFavorites(product.id);
      state = AsyncData(await favoritesRepo.loadFavorites());
    }

    return isToggle.value;
  }

  Future<bool> isProductFavorite(String id) {
    return favoritesRepo.isFavorite(id);
  }

  void clearFavorites() {
    favoritesRepo.clearFavorites();
    getFavoriteProducts();
  }
}

final favoriteProviderNotifier =
    AsyncNotifierProvider<FavoriteProvider, List<Product>>(
        () => FavoriteProvider());
