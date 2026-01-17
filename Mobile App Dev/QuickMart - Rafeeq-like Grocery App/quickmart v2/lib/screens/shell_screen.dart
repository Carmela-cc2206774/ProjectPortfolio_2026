import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickmart/providers/title_provider.dart';
import 'package:quickmart/routes/app_router.dart';

class ShellScreen extends ConsumerWidget {
  final Widget? child;
  const ShellScreen({super.key, this.child});
  // static ValueNotifier<int> titleController = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var titleProvidier = ref.watch(titleProvider);
    return Scaffold(
      body: child,
      backgroundColor: Colors.white,
//=============================app bar==========================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: (ref.watch(titleProvider.notifier).inDetailScreen)
            ? (IconButton(
                onPressed: () {
                  (ref.read(titleProvider.notifier).prevIndex == 0)
                      ? context.goNamed(AppRouter.shop.name)
                      : context.goNamed(AppRouter.fav.name);
                  ref.read(titleProvider.notifier).setPreviousTitle();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)))
            : Placeholder(
                color: const Color.fromARGB(0, 255, 255, 255),
              ),
        title: Title(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Text(
              titleProvidier,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            )),
      ),

//===================bottom navigation bar======================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.storefront_outlined,
              color: Colors.black,
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.shopping_cart, color: Colors.black),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.suit_heart, color: Colors.black),
            label: 'Favorites',
          ),
        ],
        onTap: (index) {
          ref.read(titleProvider.notifier).setInDetailScreen(false);
          ref.read(titleProvider.notifier).setNextTitle(index);
          if (index == 0) {
            context.goNamed(AppRouter.shop.name);
          } else if (index == 1) {
            context.goNamed(AppRouter.cart.name);
          } else {
            context.goNamed(AppRouter.fav.name);
          }
        },
      ),
    );
  }
}
