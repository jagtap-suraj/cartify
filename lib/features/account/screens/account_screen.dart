import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/account/widgets/custom_app_bar_content.dart';
import 'package:cartify/features/account/widgets/orders.dart';
import 'package:cartify/features/account/widgets/top_buttons.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          elevation: 0, // Remove the shadow below the app bar
          // flexibleSpace is used to add a linear gradient background to the app bar
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the children to the start and end of the row
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Image.asset(
                  'assets/images/amazon_in.png',
                  width: 120,
                  height: 45,
                  color: GlobalVariables.blackColor, // Set the color to black as by default it takes the white color
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    Icon(
                      Icons.search,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: const Column(
        children: [
          CustomAppBarContent(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 10),
          Orders(),
        ],
      ),
    );
  }
}
