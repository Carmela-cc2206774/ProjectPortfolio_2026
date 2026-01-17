import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:quickmart/providers/title_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String title;

  const ProductDetailsScreen({super.key, required this.title});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  ValueNotifier<bool> inFavesController = ValueNotifier<bool>(false);
  late ValueNotifier<int> quantityController = setQuantityController();
  bool showDescription = false;

  CartItem? getCartItem() {
    final Product product = ref
        .read(productNotifierProvider)
        .firstWhere((p) => widget.title == p.getTitle);
    final cartItems = ref.watch(cartNotifierProvider);
    CartItem? cartItem;
    try {
      cartItem = cartItems
          .firstWhere((item) => (item.getProductName == product.getTitle));
    } catch (e) {
      cartItem = null;
    }
    return cartItem;
  }

  ValueNotifier<int> setQuantityController() {
    final CartItem? cartItem = getCartItem();
    return ValueNotifier<int>((cartItem == null) ? 1 : cartItem.getQuantity);
  }

  ValueNotifier<bool> setInFavesController() {
    var p = ref
        .read(productNotifierProvider)
        .firstWhere((p) => widget.title == p.getTitle);

    var isFavorite = ref.watch(favoritesNotifierProvider)[p];

    return ValueNotifier(isFavorite ?? false);
  }

  faveIcon(bool inFaves) => (!inFaves)
      ? Icon(
          CupertinoIcons.heart,
          size: 30,
        )
      : Icon(
          CupertinoIcons.heart_fill,
          size: 30,
          color: const Color.fromARGB(255, 25, 133, 28),
        );

  Widget starRatingIcons(int index) {
    Product p = ref
        .read(productNotifierProvider)
        .firstWhere((p) => widget.title == p.getTitle);
    int rating = p.getRating;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Icon(
        CupertinoIcons.star_fill,
        color: (index < rating)
            ? const Color.fromARGB(255, 209, 158, 4)
            : const Color.fromARGB(255, 165, 165, 165),
      ),
    );
  }

  IconData showDescriptionArrowIcon(bool flag) => (flag)
      ? Icons.keyboard_arrow_up_rounded
      : Icons.keyboard_arrow_down_rounded;

  @override
  Widget build(BuildContext context) {
    ref.read(titleProvider.notifier).setInDetailScreen(true);
    final favs = ref.watch(favoritesNotifierProvider);
    final Product product = ref
        .read(productNotifierProvider)
        .firstWhere((p) => widget.title == p.getTitle);

    final CartItem? cartItem = getCartItem();

    inFavesController = setInFavesController();

    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20.0, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 19),
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "assets/images/${product.getImageName}",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: (product.getTitle.length < 23) ? 40 : 80,
                      width: 320,
                      child: Text(
                        product.getTitle,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: (product.getTitle.length < 30) ? 16 : 15),
                        softWrap: true,
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Text(product.getCategory.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.7,
                          fontSize: 8,
                          color: Color.fromARGB(255, 150, 150, 150),
                        ))
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    setState(() {
                      inFavesController.value = !inFavesController.value;
                    });
                    (inFavesController.value)
                        ? ref
                            .read(favoritesNotifierProvider.notifier)
                            .addToFaves(product)
                        : ref
                            .read(favoritesNotifierProvider.notifier)
                            .removeFromeFaves(product);
                  },
                  icon: faveIcon(inFavesController.value),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          if (quantityController.value > 0) {
                            quantityController = ValueNotifier<int>(
                                quantityController.value - 1);
                          }
                        });
                      },
                      icon: Icon(Icons.remove),
                      color: const Color.fromARGB(255, 114, 114, 114),
                      iconSize: 28),
                  SizedBox(
                    height: 30,
                    width: 48,
                    child: Center(
                      child: Text(quantityController.value.toString(),
                          style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantityController =
                            ValueNotifier<int>(quantityController.value + 1);
                      });
                    },
                    icon: Icon(Icons.add),
                    color: Colors.green,
                    iconSize: 28,
                  ),
                  Spacer(),
                  Text(
                    "QR ${product.getPrice}  ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Row(
                children: [
                  Text(
                    "Product Detail",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(showDescriptionArrowIcon(showDescription)),
                    onPressed: () => setState(() {
                      showDescription = !showDescription;
                    }),
                  )
                ],
              ),
            ),
            if (showDescription)
              SizedBox(
                height: (product.getTitle.length < 23) ? 100 : 70,
                width: 340,
                child: Text(
                  product.getDescription,
                  style: TextStyle(
                      fontSize: 8,
                      color: const Color.fromARGB(255, 114, 114, 114),
                      letterSpacing: 1),
                ),
              ),
            Row(
              children: [
                Text(
                  "Review",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
                ),
                Spacer(),
                Row(
                  children: List.generate(5, (index) => starRatingIcons(index)),
                )
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    if (quantityController.value > 0) {
                      final quantity = quantityController.value;
                      if (cartItem != null) {
                        // already in the cart
                        ref
                            .read(cartNotifierProvider.notifier)
                            .updateItemQuantity(cartItem, quantity);
                      } else {
                        // not in the cart -> make it
                        ref.read(cartNotifierProvider.notifier).addItemToCart(
                            CartItem(
                                productId: product.getProductId,
                                productName: product.getTitle,
                                category: product.getCategory,
                                imageName: product.getImageName,
                                quantity: quantity,
                                unitPrice: product.getPrice));
                      }
                      ref.read(titleProvider.notifier).setNextTitle(1);
                      context.goNamed(AppRouter.cart.name);
                    }
                  },
                  child: SizedBox(
                    height: 70,
                    width: 400,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      color: Colors.green,
                      child: Center(
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ])),
    );
  }
}
