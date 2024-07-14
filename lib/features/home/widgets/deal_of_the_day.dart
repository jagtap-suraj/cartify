import 'package:cartify/common/widgets/loader.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/home/services/home_service.dart';
import 'package:cartify/models/product.dart';
import 'package:cartify/providers/product_provider.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DealOfTheDay extends StatefulWidget {
  const DealOfTheDay({super.key});

  @override
  State<DealOfTheDay> createState() => _DealOfTheDayState();
}

class _DealOfTheDayState extends State<DealOfTheDay> {
  final HomeService homeService = HomeService();
  // Product object to store the deal of the day
  Product? dealOfTheDayProduct;
  bool _isLoading = false;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDealOfTheDay();
  }

  Future<void> fetchDealOfTheDay() async {
    const storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'x-auth-token');
    try {
      _toggleLoading();
      final res = await homeService.fetchDealOfTheDay(
        token: token!,
      );
      res.fold(
        (left) => {
          showSnackBar(context, left),
        },
        (right) {
          if (!mounted) return;
          setState(() {
            dealOfTheDayProduct = right;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    } finally {
      _toggleLoading();
    }
  }

  void saveProductDetails(Product? product) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.setProduct(product);
  }

  void navigateToProductDetailsScreen(String? productId) {
    saveProductDetails(dealOfTheDayProduct);
    context.pushNamed(
      AppRoute.productDetailsScreen.name,
      pathParameters: {
        'productId': productId!,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return dealOfTheDayProduct == null
        ? // firt show laoder and then a sizedbox if still not found
        _isLoading
            ? const Loader()
            : const SizedBox()
        : GestureDetector(
            onTap: () {
              navigateToProductDetailsScreen(dealOfTheDayProduct!.id);
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: const Text(
                    AppStrings.dealOfTheDay,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                if (dealOfTheDayProduct != null)
                  Image.network(
                    dealOfTheDayProduct!.images[0],
                    height: 235,
                    fit: BoxFit.fitHeight,
                  ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    '\$100',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
                  child: const Text(
                    'Suraj',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // listViewBuilder to show other images of the same product
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: dealOfTheDayProduct!.images
                        .map(
                          (e) => Image.network(
                            e,
                            fit: BoxFit.fitWidth,
                            width: 100,
                            height: 100,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ).copyWith(left: 15),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    AppStrings.seeAllDeals,
                    style: TextStyle(
                      color: GlobalVariables.cyanColor,
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
