import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/account/widgets/account_button.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/repository/user_repository.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  // Future<void> logoutUser() async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final userRepository = UserRepository();
  //   const storage = FlutterSecureStorage();

  //   try {
  //     // Delete user from database
  //     await userRepository.deleteUser(userProvider.user.id!);

  //     // Clear user from provider
  //     userProvider.deleteUser(userProvider.user.id!);

  //     // Delete token from secure storage
  //     await storage.delete(key: 'x-auth-token');
  //     if (!mounted) return;
  //     showSnackBar(context, 'Logged out successfully');
  //     print("sooraj logged out successfully");
  //     context.goNamed(AppRoute.authScreen.name);
  //   } catch (e) {
  //     if (!mounted) return;
  //     showSnackBar(context, 'Error logging out');
  //   }
  // }

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
            AccountButton(text: 'Log Out', onTap: () {}),
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
