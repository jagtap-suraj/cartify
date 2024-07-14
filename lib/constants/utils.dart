import 'dart:io';

import 'package:cartify/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    ),
  );
}

void showAlertDialog(BuildContext context, String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
    ),
  );
}

void showToast(String text) {
  print("sooraj showToast: $text");
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 8.0,
  );
}

//pickImages function to pick multiple images from gallery
Future<List<File>> pickImages() async {
  List<File> images = [];
  try {
    final picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();
    if (pickedImages.isNotEmpty) {
      for (int i = 0; i < pickedImages.length; i++) {
        images.add(File(pickedImages[i].path));
      }
    }
  } catch (e) {
    debugPrint("${AppStrings.errorInPickImage}: $e");
  }
  return images;
}

// ValueNotifier to refresh the product list
ValueNotifier<bool> refreshProductListNotifier = ValueNotifier(false);
