import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/models/product.dart';
import 'package:quickmart/providers/cart_provider.dart';
import 'package:quickmart/providers/favorites_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProviderNotifier);
    final favoritesState = ref.watch(favoriteProviderNotifier);
    return Container(
        padding: const EdgeInsets.all(16.0),
        child: favoritesState.when(
          data: (favorites) {
            if (favorites.isEmpty) {
              return const Center(child: Text('No Items in Favorites.'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Favorites',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          ref
                              .read(cartProviderNotifier.notifier)
                              .addAllProductsToCart(favorites);
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.add_shopping_cart),
                            SizedBox(width: 8.0),
                            Text('Add all to cart'),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 16.0),
                if (favorites.isEmpty)
                  const Center(
                    child: Text('No favorites yet'),
                  ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return buildListItem(favorites[index]);
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error: ${error.toString()}')),
        ) // end col
        );
  }

  Widget buildListItem(Product product) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppRouter.productDetails.name,
            pathParameters: {'id': product.id});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: FutureBuilder<int>(
            future: ref
                .watch(cartProviderNotifier.notifier)
                .getProductQuantity(product.id),
            builder: (context, cartProvider) {
              final productCount = cartProvider.data ?? 0;
              // if (cartProvider.connectionState == ConnectionState.waiting) {
              //   return CircularProgressIndicator();
              // }
              // if (cartProvider.connectionState == ConnectionState.waiting) {
              //   return Icon(Icons.error);
              // }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            product.imageUrl,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 8.0), // Space between image and text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      product.title.length > 15
                                          ? '${product.title.substring(0, 15)}...'
                                          : product.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.favorite),
                                      color: Colors.red,
                                      onPressed: () {
                                        final favoritesState =
                                            ref.watch(favoriteProviderNotifier);
                                        setState(() {
                                          ref
                                              .read(favoriteProviderNotifier
                                                  .notifier)
                                              .toggleFavorite(product);
                                          final favoritesState = ref
                                              .watch(favoriteProviderNotifier);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              product.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                // need empty size book inside of the image
                                const SizedBox(
                                  width: 65,
                                  height: 0,
                                ),
                                Text(
                                  '\$${product.price}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            if (productCount == 0)
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(cartProviderNotifier.notifier)
                                      .addProductToCart(product);
                                },
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.grey.shade50,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                ),
                              ),
                            if (productCount > 0)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  color: Colors.grey.shade50,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          ref
                                              .read(
                                                  cartProviderNotifier.notifier)
                                              .removeProductFromCart(product);
                                        },
                                        icon: Icon(
                                          Icons.remove,
                                        ),
                                      ),
                                      Text(
                                        productCount.toString(),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          ref
                                              .read(
                                                  cartProviderNotifier.notifier)
                                              .addProductToCart(product);
                                        },
                                        icon: Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
    );
  }
}
