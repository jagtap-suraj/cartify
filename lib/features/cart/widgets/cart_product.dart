import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/cart/services/cart_services.dart';
import 'package:cartify/features/product_details/screens/service/product_details_services.dart';
import 'package:cartify/models/product.dart';
import 'package:cartify/models/user.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsServices productDetailsServices = ProductDetailsServices();
  final CartServices cartServices = CartServices();

  Future<void> incrementProduct(Product product) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'x-auth-token');
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await productDetailsServices.addToCart(
        token: token!,
        product: product,
      );
      res.fold(
        (left) => {
          showSnackBar(context, left),
        },
        (right) {
          User user = userProvider.user.copyWith(cart: right.cart);
          userProvider.updateUser(user);
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    }
  }

  Future<void> decrementProduct(Product product) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'x-auth-token');
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await cartServices.reduceFromCart(
        token: token!,
        product: product,
      );
      res.fold(
        (left) => {
          showSnackBar(context, left),
        },
        (right) {
          User user = userProvider.user.copyWith(cart: right.cart);
          userProvider.updateUser(user);
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    }
  }

  Future<void> removeTheGivenProduct(Product product) async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'x-auth-token');
    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await cartServices.removeFromCart(
        token: token!,
        product: product,
      );
      res.fold(
        (left) => {
          showSnackBar(context, left),
        },
        (right) {
          User user = userProvider.user.copyWith(cart: right.cart);
          userProvider.updateUser(user);
          showSnackBar(context, '${product.name} removed from cart');
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart?[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

    return Dismissible(
      key: Key(product.id.toString()), // Use the product's ID as a unique key
      direction: DismissDirection.endToStart, // Swipe direction
      onDismissed: (direction) {
        // Call your method to remove the product from the cart
        removeTheGivenProduct(product);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                Image.network(
                  product.images[0],
                  fit: BoxFit.contain,
                  height: 135,
                  width: 135,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 235,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: 235,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          '\$${product.price}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: 235,
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text('Eligible for FREE Shipping'),
                      ),
                      Container(
                        width: 235,
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        child: const Text(
                          'In Stock',
                          style: TextStyle(
                            color: Colors.teal,
                          ),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black12,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => decrementProduct(product),
                        child: Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.remove,
                            size: 18,
                          ),
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 1.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.center,
                          child: Text(
                            quantity.toString(),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => incrementProduct(product),
                        child: Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.add,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
