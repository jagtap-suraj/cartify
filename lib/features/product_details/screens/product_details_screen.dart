import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cartify/common/widgets/custom_button.dart';
import 'package:cartify/common/widgets/stars.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/product_details/screens/service/product_details_services.dart';
import 'package:cartify/models/product.dart';
import 'package:cartify/models/user.dart';
import 'package:cartify/providers/product_provider.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductDetailsServices productDetailsServices = ProductDetailsServices();
  double avgRating = 0;
  double myRating = 0;

  Product product = Product(
    name: '',
    description: '',
    quantity: 0.0,
    images: [],
    category: '',
    price: 0.0,
    sellerId: '',
  );

  @override
  void initState() {
    super.initState();
    obtainProductDetails();
    calculateAverageRating();
  }

  void navigateToSearchScreen(String searchQuery) {
    context.goNamed(
      AppRoute.searchScreen.name,
      queryParameters: {
        'searchQuery': searchQuery,
      },
    );
  }

  void obtainProductDetails() {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    product = productProvider.product;
  }

  Future<void> rateProduct(double rating) async {
    try {
      const storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'x-auth-token');
      final res = await productDetailsServices.rateProduct(
        token: token!,
        productId: product.id!,
        rating: rating,
      );
      res.fold(
        (left) => {
          showSnackBar(context, left),
        },
        (right) {
          showSnackBar(context, AppStrings.productRatedSuccessfully);
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    }
  }

  void calculateAverageRating() {
    double totalRating = 0;
    if (product.ratings != null) {
      for (int i = 0; i < product.ratings!.length; i++) {
        totalRating += product.ratings![i].rating;
        if (product.ratings![i].userId == Provider.of<UserProvider>(context, listen: false).user.id) {
          myRating = product.ratings![i].rating;
        }
      }
      if (totalRating != 0) {
        avgRating = totalRating / product.ratings!.length;
      }
    }
  }

  Future<void> addToCart(Product product) async {
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
          showSnackBar(context, AppStrings.productAddedToCart);
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.id ?? '',
                  ),
                  Stars(
                    rating: avgRating,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(
                product.name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            CarouselSlider(
              items: product.images.map(
                (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 300,
              ),
            ),
            Container(
              color: GlobalVariables.black12Color,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: GlobalVariables.blackColor,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${product.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        color: GlobalVariables.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.description),
            ),
            Container(
              color: GlobalVariables.black12Color,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: AppStrings.buyNow,
                onTap: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: AppStrings.addToCart,
                onTap: () {
                  addToCart(product);
                },
                color: GlobalVariables.floatingActionButtonColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                AppStrings.rateTheProduct,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: GlobalVariables.secondaryColor,
              ),
              onRatingUpdate: (rating) {
                myRating = rating;
                rateProduct(rating);
              },
            )
          ],
        ),
      ),
    );
  }
}
