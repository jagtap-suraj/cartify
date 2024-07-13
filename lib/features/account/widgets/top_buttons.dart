import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/features/account/widgets/account_button.dart';
import 'package:flutter/material.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: AppStrings.yourOrders,
              onTap: () {},
            ),
            AccountButton(
              text: AppStrings.turnSeller,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            AccountButton(
              text: AppStrings.logOut,
              onTap: () {},
            ),
            AccountButton(
              text: AppStrings.yourWishList,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
