import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBarContent extends StatelessWidget {
  const CustomAppBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user; // To display the user's name in the app bar
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: GlobalVariables.appBarGradient,
      ),
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Row(
        children: [
          // RichText is used to display two different styles of text in the same line
          RichText(
            text: TextSpan(
              text: '${AppStrings.hello} ',
              style: const TextStyle(
                fontSize: 22,
                color: GlobalVariables.blackColor,
              ),
              children: [
                TextSpan(
                  // Display the first letter of the user's name in uppercase and the rest of the name in lowercase
                  text: user.name[0].toUpperCase() + user.name.substring(1),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
