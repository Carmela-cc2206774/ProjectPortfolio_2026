import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/category_provider.dart';
import 'package:quickmart/providers/product_provider.dart';
import 'package:quickmart/providers/title_provider.dart';
import 'package:quickmart/routes/app_router.dart';

import '../providers/favorites_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  const ProductScreen({super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    final productprovider = ref.watch(productNotifierProvider);
    var favoritesProvider = ref.watch(favoritesNotifierProvider);
    String searchQuery = '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 15, right: 15, left: 15),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, bottom: 5, right: 15),
                child: SizedBox(
                  height: 60,
                  width: 300,
                  child: TextField(
                    style: TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(151, 151, 151, 151)),
                    decoration: InputDecoration(
                      labelText: ('Search'),
                      labelStyle: TextStyle(fontSize: 12),
                      icon: Icon(CupertinoIcons.search),
                      fillColor: Color.fromARGB(151, 151, 151, 151),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        ref
                            .read(productNotifierProvider.notifier)
                            .updateProductState(searchQuery);
                      });
                    },
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    ref
                        .watch(categoryNotifierProvider.notifier)
                        .initailizeCategories();
                    setState(() {
// =========================filter by category w checkboxes=====================
                      showDialog(
                          context: context,
                          builder: (context) => CheckBoxWidget());
                    });
                  },
                  icon: Icon(
                    CupertinoIcons.line_horizontal_3_decrease_circle,
                    color: Colors.green,
                    size: 35,
                  ))
            ],
          ),
          productCardBuilder(context, productprovider)
        ],
      ),
    );
  }

// =======================cartItem getter from product==========================
  CartItem? getCartItem(Product product) {
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

  //======================heart icon manager method=============================

  heartIcon(Product product) {
    // Watch the favorite status for the product directly from the provider
    final isFavorite = ref.watch(favoritesNotifierProvider)[product] ?? false;

    return IconButton(
      alignment: Alignment.topRight,
      onPressed: () {
        // Toggle the favorite status using the provider
        if (isFavorite) {
          ref
              .read(favoritesNotifierProvider.notifier)
              .removeFromeFaves(product);
        } else {
          ref.read(favoritesNotifierProvider.notifier).addToFaves(product);
        }
      },
      icon: Icon(
        isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        size: 30,
        color: isFavorite ? const Color.fromARGB(255, 25, 133, 28) : null,
      ),
    );
  }

  //=====================product card builder widget============================

  productCardBuilder(context, final productprovider) {
    final favs = ref.watch(favoritesNotifierProvider);
    return Expanded(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 2 / 3.555,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: productprovider.length,
            itemBuilder: (context, index) {
              final Product product = productprovider[index];
              final CartItem? cartItem = getCartItem(product);

              return GestureDetector(
                onTap: () {
                  ref.read(titleProvider.notifier).setInDetailScreen(true);
                  ref.read(titleProvider.notifier).setNextTitle(0);
                  context.goNamed(AppRouter.details.name, pathParameters: {
                    'title': product.getTitle,
                  });
                },

// =============================card building===================================

                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, bottom: 12.0, right: 12, left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
// =======================favorite heart button=================================
                        heartIcon(product),
// =======================image and other info==================================
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, right: 10, left: 10),
                          child: Image.asset(
                              "assets/images/${product.getImageName}",
                              height: 110),
                        ),
                        Text(
                          product.getTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  (product.getTitle.length > 28) ? 10 : 12,
                              leadingDistribution:
                                  TextLeadingDistribution.proportional),
                        ),
                        Text(
                          product.getCategory.toUpperCase(),
                          style: TextStyle(
                              fontSize: 7,
                              letterSpacing: 0.7,
                              color: Color.fromARGB(255, 150, 150, 150),
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "QR ${product.getPrice.toString()}",
                              style: TextStyle(
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                alignment: Alignment.bottomRight,
                                onPressed: () {
                                  setState(() {
                                    if (cartItem != null) {
                                      // already in the cart
                                      ref
                                          .read(cartNotifierProvider.notifier)
                                          .updateItemQuantity(cartItem,
                                              cartItem.getQuantity + 1);
                                    } else {
                                      // not in the cart -> make it
                                      ref
                                          .read(cartNotifierProvider.notifier)
                                          .addItemToCart(CartItem(
                                              productId: product.getProductId,
                                              productName: product.getTitle,
                                              category: product.getCategory,
                                              imageName: product.getImageName,
                                              quantity: 1,
                                              unitPrice: product.getPrice));
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.add_box_rounded,
                                  color: Colors.green,
                                  size: 32,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}

// ========================== check box widget  ==============================

class CheckBoxWidget extends ConsumerStatefulWidget {
  const CheckBoxWidget({super.key});

  @override
  ConsumerState<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends ConsumerState<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    ref.watch(categoryNotifierProvider.notifier).initailizeCategories();
    Set<ProductCategory> categories =
        ref.watch(categoryNotifierProvider.notifier).categories;
    Set<String> categoriesToFilter =
        ref.watch(categoryNotifierProvider.notifier).categoriesToFilter;

    return SimpleDialog(
      children: [
        Center(
          child: Text(
            "Filter",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
        Column(
          children: List.generate(categories.length, (index) {
            return CheckboxListTile.adaptive(
              onChanged: (bool? value) {
                setState(() {
                  ref
                      .watch(categoryNotifierProvider.notifier)
                      .updateCheckedCategories(index, value!);
                  // if isChecked true =
                  (ref
                          .watch(categoryNotifierProvider.notifier)
                          .isCheckedList[index])
                      ? categoriesToFilter.add(categories.elementAt(index).name)
                      : categoriesToFilter
                          .remove(categories.elementAt(index).name);
                });
                ref
                    .read(productNotifierProvider.notifier)
                    .updateProductStateFromCategories(
                      ref
                          .watch(categoryNotifierProvider.notifier)
                          .categoriesToFilter,
                    );
              },
              value: ref.watch(categoryNotifierProvider).elementAt(index),
              title: Text(
                categories.elementAt(index).name.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                ),
              ),
              enabled: true,
            );
          }),
        ),
      ],
    );
  }
}
