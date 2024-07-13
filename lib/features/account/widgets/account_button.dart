import 'package:cartify/constants/global_variables.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const AccountButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: GlobalVariables.whiteColor, width: 0.0),
          borderRadius: BorderRadius.circular(50),
          color: GlobalVariables.whiteColor,
        ),
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: GlobalVariables.black12Color.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            side: const BorderSide(
              // This sets the border color
              color: GlobalVariables.greyColor,
              width: 0.0,
            ),
          ),
          onPressed: onTap,
          child: Text(
            text,
            style: const TextStyle(
              color: GlobalVariables.blackColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
