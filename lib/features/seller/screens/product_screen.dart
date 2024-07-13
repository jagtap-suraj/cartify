import 'package:cartify/common/widgets/loader.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/account/widgets/single_product.dart';
import 'package:cartify/features/seller/services/seller_services.dart';
import 'package:cartify/models/product.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final SellerServices sellerServices = SellerServices();
  bool _isLoading = false;
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    fetchSellerProducts();
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void fetchSellerProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      const storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'x-auth-token');
      final res = await sellerServices.fetchSellerProducts(token: token!, sellerId: userProvider.user.id!);
      if (!mounted) return;
      res.fold(
        (left) => {
          showSnackBar(context, left)
        },
        (right) => {
          products = right,
          showSnackBar(context, AppStrings.productsFetchedSuccessfully)
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    } finally {
      _toggleLoading();
    }
  }

  void deleteProduct(String productId) async {
    try {
      const storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'x-auth-token');
      final res = await sellerServices.deleteProduct(token: token!, productId: productId);
      if (!mounted) return;
      res.fold(
        (left) => {
          showSnackBar(context, left)
        },
        (right) => {
          setState(() {
            // Update the products List by removing the product with the matching productId.
            // products = products!.where((product) => product.id != productId).toList();
            // get the id from the right object and remove the product with that id
            print("Sooraj productId: $productId");
            print("Sooraj right.id: ${right.id}");
            print("Sooraj right: $right");
            products = products!.where((product) => product.id != right.id).toList();
          }),
          showSnackBar(context, AppStrings.productDeletedSuccessfully)
        },
      );
    } catch (e) {
      if (!mounted) return;
      showSnackBar(context, AppStrings.genericErrorMessage);
    } finally {
      _toggleLoading();
    }
  }

  void navigateToAddProduct() {
    context.goNamed(AppRoute.addProductScreen.name);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: () async {
                fetchSellerProducts();
              },
              child: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: SingleProduct(
                          image: productData.images[0],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteProduct(productData.id!);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: GlobalVariables.floatingActionButtonColor,
              onPressed: () {
                navigateToAddProduct();
              },
              tooltip: AppStrings.addProduct, // Shows on long press
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          );
  }
}
