import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickmart/models/cart_item.dart';
import 'package:quickmart/providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItemsProvider = ref.watch(cartNotifierProvider);

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0, top: 25),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: cartItemsProvider.length,
                  itemBuilder: (context, index) {
                    final CartItem cartItem = cartItemsProvider[index];
                    return SizedBox(
                        height: 120,
                        width: double.infinity,
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 7, left: 12, right: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Image.asset(
                                    "assets/images/${cartItem.getImageName}",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: SizedBox(
                                    width: 204,
                                    height: 172,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.getProductName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: (cartItem
                                                        .getProductName.length >
                                                    28)
                                                ? 7.19
                                                : 9,
                                          ),
                                          softWrap: true,
                                          maxLines: null,
                                          overflow: TextOverflow.visible,
                                        ),
                                        Text(
                                          cartItem.getCategory.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 5,
                                              letterSpacing: 0.7,
                                              color: Color.fromARGB(
                                                  255, 150, 150, 150),
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.start,
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  int currentQuantity =
                                                      cartItem.getQuantity;

                                                  ref
                                                      .read(cartNotifierProvider
                                                          .notifier)
                                                      .updateItemQuantity(
                                                          cartItem,
                                                          --currentQuantity);
                                                });
                                              },
                                              icon: Icon(Icons.remove),
                                              color: const Color.fromARGB(
                                                  255, 114, 114, 114),
                                            ),
                                            SizedBox(
                                              height: 25,
                                              width: 33,
                                              child: Center(
                                                child: Text(
                                                    cartItem.getQuantity
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10)),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  int currentQuantity =
                                                      cartItem.getQuantity;

                                                  ref
                                                      .read(cartNotifierProvider
                                                          .notifier)
                                                      .updateItemQuantity(
                                                          cartItem,
                                                          ++currentQuantity);
                                                });
                                              },
                                              icon: Icon(Icons.add),
                                              color: Colors.green,
                                            ),
                                            SizedBox(
                                                height: 35,
                                                width: 75,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 7.0),
                                                  child: Card(
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8))),
                                                    color: const Color.fromARGB(
                                                        255, 241, 241, 241),
                                                    child: Center(
                                                      child: Text(
                                                        'QR ${cartItem.getSubTotal.toStringAsFixed(2)}',
                                                        style: TextStyle(
                                                            fontSize: 6,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                114, 114, 114)),
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ref
                                          .read(cartNotifierProvider.notifier)
                                          .removeItem(cartItem);
                                    });
                                  },
                                  icon: Icon(Icons.close_rounded),
                                  color: Color.fromARGB(255, 209, 209, 209),
                                  iconSize: 20,
                                  alignment: Alignment.topRight,
                                )
                              ],
                            ),
                          ),
                        ));
                  })),
          SizedBox(
            height: 70,
            width: 330,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              color: Colors.green,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80.0, right: 0),
                    child: Text(
                      'Go To Checkout',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                      height: 30,
                      width: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          color: const Color.fromARGB(255, 25, 133, 28),
                          child: Center(
                            child: Text(
                              'QR ${ref.watch(cartNotifierProvider.notifier).cartTotal}',
                              style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      const Color.fromARGB(255, 207, 235, 207)),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
