import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/providers/title_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = ref.watch(favoritesNotifierProvider);
    final cartProvider = ref.watch(cartNotifierProvider);

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0, top: 25),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
                  favoritesProvider.values.where((value) => value).length,
              itemBuilder: (context, index) {
                List<Product> inFavorites = favoritesProvider.keys
                    .where((k) => favoritesProvider[k] == true)
                    .toList();
                final Product product = inFavorites[index];
                return SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(titleProvider.notifier).setInDetailScreen(true);
                      ref.read(titleProvider.notifier).setNextTitle(0);
                      context.goNamed(AppRouter.details.name, pathParameters: {
                        'title': product.getTitle,
                      });
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 7,
                          left: 12,
                          right: 10,
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.asset(
                                "assets/images/${product.getImageName}",
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 10),
                              child: SizedBox(
                                width: 190,
                                height: 172,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.getTitle,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: (product.getTitle.length > 28)
                                            ? 7.19
                                            : 9,
                                      ),
                                      softWrap: true,
                                      maxLines: null,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      product.getCategory.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 5,
                                        letterSpacing: 0.7,
                                        color:
                                            Color.fromARGB(255, 150, 150, 150),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Spacer(),
                                    Text(
                                      'QR ${product.getPrice}',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  ref
                                      .read(favoritesNotifierProvider.notifier)
                                      .removeFromeFaves(product);
                                });
                              },
                              icon: Icon(Icons.close_rounded),
                              color: Color.fromARGB(255, 209, 209, 209),
                              iconSize: 20,
                              alignment: Alignment.topRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                List<Product> products =
                    ref.read(favoritesNotifierProvider.notifier).favesToCart();
                for (Product product in products) {
                  var cartFiltered = cartProvider.where((cartItem) =>
                      cartItem.getProductName == product.getTitle);
                  if (cartFiltered.isEmpty) {
                    // not in cart
                    ref.read(cartNotifierProvider.notifier).addItemToCart(
                        CartItem(
                            category: product.getCategory,
                            imageName: product.getImageName,
                            productId: product.getProductId,
                            productName: product.getTitle,
                            quantity: 1,
                            unitPrice: product.getPrice));
                  } else {
                    ref.read(cartNotifierProvider.notifier).updateItemQuantity(
                        cartFiltered.first, cartFiltered.first.getQuantity + 1);
                  }
                }
              });
              ref.read(titleProvider.notifier).setNextTitle(1);
              context.goNamed(AppRouter.cart.name);
            },
            child: SizedBox(
              height: 70,
              width: 330,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Add All Favorites to Cart',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
