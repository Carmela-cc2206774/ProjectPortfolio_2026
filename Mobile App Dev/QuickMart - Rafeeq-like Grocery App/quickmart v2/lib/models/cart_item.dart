class CartItem {
  String _productId;
  String _productName;
  String _category;
  String _imageName;
  int _quantity;
  double _unitPrice;

  CartItem({
    required String productId,
    required String productName,
    required String category,
    required String imageName,
    required int quantity,
    required double unitPrice,
  })  : _productId = productId,
        _productName = productName,
        _category = category,
        _imageName = imageName,
        _quantity = quantity,
        _unitPrice = unitPrice;

  String get getProductId => _productId;
  set setProductId(String n) => _productId = n;

  String get getProductName => _productName;
  set setProductName(String n) => _productName = n;

  String get getCategory => _category;
  set setCategory(String n) => _category = n;

  String get getImageName => _imageName;
  set setImageName(String n) => _imageName = n;

  int get getQuantity => _quantity;
  void set setQuantity(int n) => _quantity = n;

  double get getUnitPrice => _unitPrice;
  set setUnitPrice(double n) => _unitPrice = n;

  double get getSubTotal => _quantity * _unitPrice;

  // factory CartItem.fromJson(Map<String, dynamic> jsonmap) {
  //   return CartItem(
  //       productId: jsonmap['productId'] ?? '',
  //       productName: jsonmap['productName'] ?? '',
  //       category: jsonmap['category'] ?? '',
  //       imageName: jsonmap['imageName'] ?? '',
  //       quantity: jsonmap['quantity'] ?? 0,
  //       unitPrice: jsonmap['unitPrice'] ?? 0.0);
  // }
}
