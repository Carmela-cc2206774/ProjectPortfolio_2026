import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:dio/dio.dart';
import 'package:quickmart/repo/product_repo.dart';

class CartRepository {
  static List<CartItem> _cartItems = [];
  static bool isCartEmpty = true;
  final dio = Dio();
  final urlPath = "https://quickmart.codedbyyou.com/api";

  Future<List<CartItem>> getCartItems() async {
    _cartItems = [];
    isCartEmpty = true;
    try {
      Response response = await dio.get("$urlPath/cart");
      var receivedAPIData = response.data as List;
      for (Map<String, dynamic> c in receivedAPIData) {
        Product product = await ProductRepo().getProductById(c['productId']);
        c['imageUrl'] = product.imageUrl;
        c['name'] = product.title;
        c['unitPrice'] = product.price;
        c['category'] = product.category;
        CartItem cartItem = CartItem.fromJson(c);
        _cartItems.add(cartItem);
        isCartEmpty = false;
      }
      print('CART GET Success: ${response.statusCode}');
    } catch (e) {
      print('CART GET Failed: $e');
    }
    return _cartItems;
  }

  Future<List<CartItem>> getCartItem(Product product) async {
    try {
      Response response = await dio.get("$urlPath/cart");
      var receivedAPIData = response.data as List;
      for (Map<String, dynamic> c in receivedAPIData) {
        Product product = await ProductRepo().getProductById(c['productId']);
        c['imageUrl'] = product.imageUrl;
        c['name'] = product.title;
        c['unitPrice'] = product.price;
        c['category'] = product.category;
        CartItem cartItem = CartItem.fromJson(c);
        _cartItems.add(cartItem);
        isCartEmpty = false;
      }
      print('CART GET Success: ${response.statusCode}');
    } catch (e) {
      print('CART GET Failed: $e');
    }
    return _cartItems;
  }

  bool getIsCartEmpty() => isCartEmpty;

  addProduct(Product product) async {
    bool itemExists = _cartItems.any((item) => item.id == product.id);
    int quantity = (itemExists)
        ? _cartItems.firstWhere((item) => item.id == product.id).quantity + 1
        : 1;
    Response response;
    try {
      if (itemExists) {
        response = await dio
            .put('$urlPath/cart/${product.id}', data: {"quantity": quantity});
        print('CART PUT Success: ${response.data}');
      } else {
        response = await dio.post('$urlPath/cart',
            data: {"productId": product.id, "quantity": quantity});
        print('CART POST Success: ${response.statusCode}');
      }
    } catch (e) {
      (itemExists)
          ? print('CART PUT Failed: $e')
          : print('CART POST Failed: $e');
    }
  }

  Future<void> removeProduct(Product product) async {
    final quantity = await getProductQuantity(product.id);
    bool toDelete = quantity < 2;
    try {
      Response response;
      if (toDelete) {
        response = await dio.delete("$urlPath/cart/${product.id}");
        print('CART DELETE Success: ${response.statusCode}');
      } else {
        response = await dio.put('$urlPath/cart/${product.id}',
            data: {"quantity": (quantity - 1)});
        print('CART PUT Success: ${response.statusCode}');
      }
    } catch (e) {
      (toDelete)
          ? print('CART DELETE Failed: $e')
          : print('CART PUT Failed: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      Response response = await dio.delete("$urlPath/cart");
      print('CART CLEAR Success: ${response.data}');
    } catch (e) {
      print('CART CLEAR Failed: $e');
    }
  }

  double getTotalPrice() {
    return _cartItems.fold(
        0.0, (total, item) => total + item.calculateTotalPrice());
  }

  Future<bool> isProductInCart(String id) async {
    try {
      Response response = await dio.get("$urlPath/cart/$id");

      Product product =
          await ProductRepo().getProductById(response.data["productId"]);

      print('CART GET Success: ${response.statusCode}');
      return true;
    } catch (e) {
      print('CART GET Failed: $e');
      return false;
    }
  }

  Future<int> getProductQuantity(String id) async {
    try {
      Response response = await dio.get('$urlPath/cart/$id');
      print('GET QUANTITY Sucess: ${response.statusCode}');
      return response.data["quantity"];
    } catch (e) {
      print('GET QUANTITY Failed: $e');
      return 0;
    }
  }
}

final cartRepository = CartRepository();
