import 'dart:developer';

import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_profile.dart';
import 'package:e_health_monitoring_system_frontend/screens/home_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/patient_service.dart';
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
  final _service = PatientService();

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
                    onPressed: () async {
                      try {
                        var resp = await _service.completeProfile(
                          PatientProfile(
                            lastName: firstNameController.text,
                            phoneNumber: phoneNumberController.text,
                            cnp: cnpController.text,
                            firstName: firstNameController.text,
                          ),
                        );
                        if (resp.statusCode == 200) {
                          navigator.pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        } else {
                          WidgetsHelper.showCustomSnackBar(
                            message: StringsHelper.internalError,
                          );
                        }
                      } on Exception catch (e) {
                        log(e.toString());
                        WidgetsHelper.showCustomSnackBar(
                          message: StringsHelper.internalError,
                        );
                      }
                    },
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
