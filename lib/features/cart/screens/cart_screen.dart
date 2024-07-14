import 'package:cartify/common/widgets/custom_button.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/cart/widgets/cart_product.dart';
import 'package:cartify/features/cart/widgets/cart_subtotal.dart';
import 'package:cartify/features/home/widgets/address_box.dart';
import 'package:cartify/features/product_details/screens/service/product_details_services.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final ProductDetailsServices productDetailsServices = ProductDetailsServices();

  void navigateToSearchScreen(String searchQuery) {
    context.goNamed(
      AppRoute.searchScreen.name,
      queryParameters: {
        'searchQuery': searchQuery,
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    // Calculate the sum of the cart items by multiplying the quantity of each item with its price
    user.cart?.map((e) => sum += e['quantity'] * e['product']['price'] as int).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    // The purpose of Material widget is to give some elevation and border radius to the TextFormField
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    // We could have used our CustomTextFormField but design differs
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          // We used InkWell as when we click on it, it gives splash effect
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: GlobalVariables.blackColor,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: GlobalVariables.whiteColor,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: GlobalVariables.black38Color,
                            width: 1,
                          ),
                        ),
                        hintText: AppStrings.searchCartify,
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Mic icon
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Icon(Icons.mic, color: GlobalVariables.blackColor, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AddressBox(),
            const CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Proceed to Buy (${user.cart!.length} items)',
                onTap: () {},
                color: GlobalVariables.primaryColor,
              ),
            ),
            const SizedBox(height: 15),
            Container(
              color: Colors.black12.withOpacity(0.08),
              height: 1,
            ),
            const SizedBox(height: 5),
            ListView.builder(
              itemCount: user.cart?.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
