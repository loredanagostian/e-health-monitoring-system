import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var cnpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appBarTitle: StringsHelper.completeProfile),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                CustomTextField(
                  textFieldType: TextFieldType.firstName,
                  controller: firstNameController,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.lastName,
                  controller: lastNameController,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.phoneNumber,
                  controller: phoneNumberController,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.cnp,
                  controller: cnpController,
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.37),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    text: StringsHelper.finish,
                    icon: Icons.arrow_forward_ios,
                    // TODO: integrate BE functionality and navigate to HomePage
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
