import 'package:cartify/models/product.dart';
import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  Product _product = Product(
    name: '',
    description: '',
    quantity: 0.0,
    images: [],
    category: '',
    price: 0.0,
    sellerId: '',
  );

  Product get product => _product;

  void setProduct(Product? product) {
    _product = product ??
        Product(
          name: '',
          description: '',
          quantity: 0.0,
          images: [],
          category: '',
          price: 0.0,
          sellerId: '',
        );
    notifyListeners();
  }
}
