class CartItem {
  final String id, name, imageUrl, category;
  final double unitPrice;

  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    required this.imageUrl,
    required this.category,
  });

  CartItem.empty()
      : id = "",
        name = "",
        unitPrice = 0,
        quantity = 0,
        imageUrl = "",
        category = "";

  calculateTotalPrice() => unitPrice * quantity;

  factory CartItem.fromJson(Map<String, dynamic> jsonmap) {
    return CartItem(
        id: jsonmap['productId'] ?? '',
        name: jsonmap['productName'] ?? '',
        category: jsonmap['category'] ?? '',
        imageUrl: jsonmap['imageUrl'] ?? '',
        quantity: jsonmap['quantity'] ?? 0,
        unitPrice: jsonmap['unitPrice'] ?? 0.0);
  }

  static Map<String, dynamic> toJson(CartItem cartItem) {
    return {
      'productId': cartItem.id,
      'productName': cartItem.name,
      'category': cartItem.category,
      'imageUrl': cartItem.imageUrl,
      'quantity': cartItem.quantity,
      'unitPrice': cartItem.unitPrice
    };
  }
}
