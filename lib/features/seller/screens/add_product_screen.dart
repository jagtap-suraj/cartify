import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cartify/common/widgets/custom_button.dart';
import 'package:cartify/common/widgets/custom_textfield.dart';
import 'package:cartify/common/widgets/loader.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/seller/services/seller_services.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _isLoading = false;
  bool _isValidCategory = false;
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final SellerServices sellerServices = SellerServices();

  String? category;
  List<File> images = [];
  final _addProductFormKey = GlobalKey<FormState>();

  bool _validateCategory() {
    if (category == null) {
      setState(() {
        _isValidCategory = false; // Step 2: Update the variable based on category selection
      });
      showSnackBar(context, 'Please select a category.'); // Optionally show a snackbar message
      return false;
    } else {
      setState(() {
        _isValidCategory = true;
      });
      return true;
    }
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void addProduct() async {
    if (_addProductFormKey.currentState!.validate() && _validateCategory() && images.isNotEmpty) {
      _toggleLoading();
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      try {
        const storage = FlutterSecureStorage();
        final String? token = await storage.read(key: 'x-auth-token');
        final res = await sellerServices.addProduct(
          name: productNameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          quantity: double.parse(quantityController.text),
          category: category!,
          images: images,
          sellerId: userProvider.user.id!,
          sellerName: userProvider.user.name,
          token: token!,
        );
        if (!mounted) return;
        res.fold(
          (left) => {
            showSnackBar(context, left)
          },
          (right) => {
            _addProductFormKey.currentState!.reset(),
            setState(() {
              images = [];
              category = null;
              // Reset any other state variables if necessary
            }),
            showSnackBar(context, AppStrings.productAddedSuccessfully)
          },
        );
      } catch (e) {
        if (!mounted) return;
        showSnackBar(context, AppStrings.genericErrorMessage);
      } finally {
        _toggleLoading();
      }
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            AppStrings.addProduct,
            style: TextStyle(
              color: GlobalVariables.blackColor,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Form(
                key: _addProductFormKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      images.isNotEmpty
                          ? CarouselSlider(
                              items: images.map(
                                (i) {
                                  return Builder(
                                    builder: (BuildContext context) => GestureDetector(
                                      onTap: selectImages,
                                      child: Image.file(
                                        i,
                                        fit: BoxFit.cover,
                                        height: 200,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: 200,
                                enableInfiniteScroll: false,
                              ),
                            )
                          : GestureDetector(
                              onTap: selectImages,
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(10),
                                dashPattern: const [
                                  10,
                                  4
                                ],
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        AppStrings.selectProductImages,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        controller: productNameController,
                        hintText: AppStrings.productName,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: descriptionController,
                        hintText: AppStrings.productDescription,
                        maxLines: 7,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: priceController,
                        hintText: AppStrings.productPrice,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: quantityController,
                        hintText: AppStrings.productQuantity,
                        textInputType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: DropdownButton<String>(
                          value: category,
                          hint: const Text(AppStrings.selectACategory),
                          padding: const EdgeInsets.only(right: 10),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: GlobalVariables.productCategories.map((String item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newVal) {
                            setState(
                              () {
                                category = newVal;
                                _isValidCategory = true;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        color: GlobalVariables.floatingActionButtonColor,
                        text: AppStrings.addProduct,
                        onTap: addProduct,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
