import 'package:flutter/material.dart';

RegExp emailRegex = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$');

class GlobalVariables {
  // COLORS
  static const appBarGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 29, 201, 192),
      Color.fromARGB(255, 125, 221, 216),
    ],
    stops: [
      0.5,
      1.0
    ],
  );

  static const addressBoxGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 114, 226, 221),
      Color.fromARGB(255, 162, 236, 233),
    ],
    stops: [
      0.5,
      1.0
    ],
  );

  static const primaryColor = Color.fromARGB(255, 29, 201, 192);
  static const lightPrimaryColor = Color.fromARGB(255, 188, 233, 231);
  static const secondaryColor = Color.fromRGBO(255, 153, 0, 1);
  static const backgroundColor = Colors.white;
  static const Color greyBackgroundColor = Color(0xffebecee);
  static var selectedNavBarColor = Colors.cyan[800]!;
  static const unselectedNavBarColor = Colors.black87;
  static const blackColor = Colors.black;
  static const black38Color = Colors.black38;
  static const black12Color = Colors.black12;
  static const greyColor = Colors.grey;
  static const whiteColor = Colors.white;
  static const cyanColor = Colors.cyan;
  static const floatingActionButtonColor = Color.fromARGB(255, 29, 201, 192);

  // STATIC IMAGES
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  static const List<Map<String, String>> categoryImages = [
    {
      'title': 'Mobiles',
      'image': 'assets/images/mobiles.jpeg',
    },
    {
      'title': 'Essentials',
      'image': 'assets/images/essentials.jpeg',
    },
    {
      'title': 'Appliances',
      'image': 'assets/images/appliances.jpeg',
    },
    {
      'title': 'Books',
      'image': 'assets/images/books.jpeg',
    },
    {
      'title': 'Fashion',
      'image': 'assets/images/fashion.jpeg',
    },
  ];

  static const List<String> productCategories = [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
    'Miscellaneous',
  ];

  static const List<String> userTypes = [
    'user',
    'seller',
  ];
}

enum TextFieldType {
  text,
  email,
  password
}

enum UserType {
  user,
  seller
}

//TODO: use enum in backend and frontend
enum ProductType {
  mobile,
  essential,
  appliance,
  book,
  fashion,
  miscellaneous
}
