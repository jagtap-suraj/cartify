import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:cartify/features/account/widgets/single_product.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  // temporary list of images
  final List<String> tempList = [
    'https://plus.unsplash.com/premium_photo-1717529137998-14eb452fe28e?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1717529137998-14eb452fe28e?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1717529137998-14eb452fe28e?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1717529137998-14eb452fe28e?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1717529137998-14eb452fe28e?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                AppStrings.yourOrders,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                AppStrings.seeAll,
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        // display order
        Container(
          height: 170, // If we don't set the height, it will give renderBoxFlow error
          padding: const EdgeInsets.only(
            left: 10,
            top: 20,
            right: 0,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            // itemBuilder is a callback function that is called for each item (or widget)
            //that needs to be built in the list.
            //For instance, if you needed to navigate to a new screen or show a dialog
            //when a SingleProduct is tapped, you would use context to do so.
            itemBuilder: (context, index) {
              return SingleProduct(
                image: tempList[index],
              );
            },
          ),
        )
      ],
    );
  }
}
