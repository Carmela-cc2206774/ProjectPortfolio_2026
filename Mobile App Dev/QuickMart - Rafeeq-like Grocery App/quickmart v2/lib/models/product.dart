class Product {
  String _productId;
  String _title;
  String _description;
  String _category;
  String _imageName;
  int _rating;
  double _price;

  Product({
    required String productId,
    required String title,
    required String category,
    required String description,
    required double price,
    required int rating,
    required String imageName,
  })  : _productId = productId,
        _title = title,
        _category = category,
        _description = description,
        _price = price,
        _rating = rating,
        _imageName = imageName;

  String get getProductId => _productId;
  set setProductId(String n) => _productId = n;

  String get getTitle => _title;
  set setTitle(String n) => _title = n;

  String get getDescription => _description;
  set setDescription(String n) => _description = n;

  String get getCategory => _category;
  set setCategory(String n) => _category = n;

  String get getImageName => _imageName;
  set setImageName(String n) => _imageName = n;

  int get getRating => _rating;
  set setRating(int n) => _rating = (n >= 0) ? n : _rating;

  double get getPrice => _price;
  set setPrice(double n) => _price = (n >= 0) ? n : _price;

  factory Product.fromJson(Map<String, dynamic> jsonmap) {
    return Product(
      productId: jsonmap['productId'] ?? '',
      title: jsonmap['title'] ?? '',
      description: jsonmap['description'] ?? '',
      category: jsonmap['category'] ?? '',
      imageName: jsonmap['imageName'] ?? '',
      rating: jsonmap['rating'] ?? 0,
      price: jsonmap['price'] ?? 0.0,
    );
  }
}

enum ProductCategory {
  dairy,
  fruit,
  vegetable,
  bakery,
  meat,
  vegan;

  static ProductCategory fromJson(String category) {
    return switch (category.toLowerCase()) {
      'dairy' => ProductCategory.dairy,
      'fruit' => ProductCategory.fruit,
      'vegetable' => ProductCategory.vegetable,
      'bakery' => ProductCategory.bakery,
      'meat' => ProductCategory.meat,
      'vegan' => ProductCategory.vegan,
      _ => throw Exception('Category $category does not exist.'),
    };
  }
}
