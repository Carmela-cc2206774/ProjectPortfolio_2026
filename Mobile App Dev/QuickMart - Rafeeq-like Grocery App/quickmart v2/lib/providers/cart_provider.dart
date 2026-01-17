import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cart_item.dart';

class CartProvider extends Notifier<List<CartItem>> {
  List<CartItem> cartItems = [];
  double cartTotal = 0;

  @override
  List<CartItem> build() {
    initializeCart();
    return [];
  }

  void initializeCart() async {
    state = cartItems;
  }

  void addItemToCart(CartItem cartItem) {
    cartItems = [...cartItems, cartItem];
    state = cartItems;
    getCartTotal();
  }

  void removeItem(CartItem cartItem) {
    cartItems.remove(cartItem);
    state = cartItems;
    getCartTotal();
  }

  void updateItemQuantity(CartItem cartItem, int quantity) {
    if (quantity != 0) {
      int index = cartItems.indexOf(cartItem);
      cartItems[index].setQuantity = quantity;
      state = cartItems;
      getCartTotal();
    } else {
      removeItem(cartItem);
    }
  }

  void getCartTotal() {
    cartTotal = 0;
    for (var cartItem in cartItems) {
      cartTotal += cartItem.getSubTotal;
    }
    cartTotal = double.parse(cartTotal.toStringAsFixed(2));
  }
}

final cartNotifierProvider =
    NotifierProvider<CartProvider, List<CartItem>>(() => CartProvider());
