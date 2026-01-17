import 'package:go_router/go_router.dart';
import 'package:quickmart/screens/cart_screen.dart';
import 'package:quickmart/screens/favorites_screen.dart';
import 'package:quickmart/screens/product_details_screen.dart';
import 'package:quickmart/screens/product_screen.dart';
import 'package:quickmart/screens/shell_screen.dart';

class AppRouter {
  static const shop = (name: 'shop', path: '/');
  static const details = (name: 'details', path: '/details');
  static const cart = (name: 'cart', path: '/cart');
  static const fav = (name: 'favorite', path: '/favorite');

  static final router = GoRouter(initialLocation: shop.path, routes: [
    ShellRoute(
        builder: (context, state, child) => ShellScreen(child: child),
        routes: [
          GoRoute(
              name: shop.name,
              path: shop.path,
              builder: (context, state) => const ProductScreen(),
              routes: [
                GoRoute(
                    name: details.name,
                    path: "${details.path}/:title",
                    builder: (context, state) {
                      final title = state.pathParameters['title'];
                      return ProductDetailsScreen(title: title!);
                    }),
                GoRoute(
                    name: cart.name,
                    path: cart.path,
                    builder: (context, state) => const CartScreen()),
                GoRoute(
                    name: fav.name,
                    path: fav.path,
                    builder: (context, state) => const FavoritesScreen())
              ])
        ]),
  ]);
}
