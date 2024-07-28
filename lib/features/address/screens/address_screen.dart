import 'package:cartify/common/widgets/custom_textfield.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/payment/services/phonepe_service.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final flatBuildingController = TextEditingController();
  final areaController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  final phonePeService = PhonePeService();

  @override
  void initState() {
    super.initState();
    phonePeService.initPhonePay();
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAddress = context.watch<UserProvider>().user.address;
    final tempAddress = "101 Main Street, 5th Cross, 3rd Block, Bangalore - 560001";
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (tempAddress != null)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: GlobalVariables.black12Color),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          tempAddress,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: AppStrings.flatHouseNoBuilding,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: AppStrings.areaStreet,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: AppStrings.pincode,
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: AppStrings.townCity,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // a button to test the payment
              ElevatedButton(
                onPressed: () async {
                  final paymentResponse = await phonePeService.startPGTransaction();
                  print("sooraj payment response: $paymentResponse");
                },
                child: const Text('Test Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
