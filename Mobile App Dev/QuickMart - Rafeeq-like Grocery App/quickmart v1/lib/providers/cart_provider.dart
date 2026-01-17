import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cart.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/repo/cart_repo.dart';

class CartProvider extends AsyncNotifier<Cart> {
  final CartRepository _cartRepo;
  List<CartItem> items = [];
  bool isLoading = false;

  CartProvider(this._cartRepo) : super();
  Cart cart = Cart([]);

  @override
  Cart build() {
    getCart();
    return Cart([]);
  }

  Future<Cart> getCart() async {
    var items = await _cartRepo.getCartItems();
    state = AsyncData(Cart(items));
    return Cart(items);
  }

  bool isCartEmpty() {
    return _cartRepo.getIsCartEmpty();
  }

  Future<bool> isProductInCart(Product product) {
    return _cartRepo.isProductInCart(product.id);
  }

  Future<void> addProductToCart(Product product) async {
    _cartRepo.addProduct(product);
    getCart();
  }

  Future<void> removeProductFromCart(Product product) async {
    _cartRepo.removeProduct(product);
    getCart();
  }

  void clearCart() {
    _cartRepo.clearCart();
    state = AsyncData(Cart([]));
  }

  double getTotalPrice() {
    return _cartRepo.getTotalPrice();
  }

  Future<int> getProductQuantity(String productId) {
    return _cartRepo.getProductQuantity(productId);
  }

  Future<void> addAllProductsToCart(List<Product> products) async {
    products.forEach(_cartRepo.addProduct);
    getCart();
  }
}

final cartProviderNotifier = AsyncNotifierProvider<CartProvider, Cart>(
    () => CartProvider(cartRepository));
