import 'dart:developer';

import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/patient_profile.dart';
import 'package:e_health_monitoring_system_frontend/screens/main_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/onboarding_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/patient_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

// TODO: this should be a proper form and provide validation
class PatientProfileForm extends StatefulWidget {
  final List<Widget> Function(
    BuildContext,
    TextEditingController firstNameController,
    TextEditingController lastNameController,
    TextEditingController phoneNumberController,
    TextEditingController cnpController,
  )
  builder;
  final String appBarTitle;
  const PatientProfileForm({
    super.key,
    required this.appBarTitle,
    required this.builder,
  });

  @override
  State<StatefulWidget> createState() => _PatientProfileFormState();
}

class _PatientProfileFormState extends State<PatientProfileForm> {
  @override
  Widget build(BuildContext context) {
    var firstNameController = TextEditingController();
    var lastNameController = TextEditingController();
    var phoneNumberController = TextEditingController();
    var cnpController = TextEditingController();

    return Scaffold(
      appBar: CustomAppbar(appBarTitle: widget.appBarTitle),
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
                ...widget.builder(
                  context,
                  lastNameController,
                  phoneNumberController,
                  cnpController,
                  firstNameController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CompleteProfileScreen extends StatelessWidget {
  const CompleteProfileScreen({super.key});
  final _service = const PatientService();

  @override
  Widget build(BuildContext context) {
    return PatientProfileForm(
      appBarTitle: StringsHelper.completeProfile,
      builder:
          (
            ctx,
            lastNameController,
            phoneNumberController,
            cnpController,
            firstNameController,
          ) => [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.37),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomButton(
                text: StringsHelper.finish,
                icon: Icons.arrow_forward_ios,
                onPressed: () async {
                  try {
                    var profile = PatientProfile(
                      lastName: lastNameController.text,
                      phoneNumber: phoneNumberController.text,
                      cnp: cnpController.text,
                      firstName: firstNameController.text,
                    );
                    var resp = await _service.completeProfile(profile);
                    if (resp.statusCode == 200) {
                      navigator.pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
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
    );
  }
}

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});
  final _service = const PatientService();

  @override
  Widget build(BuildContext context) {
    return PatientProfileForm(
      appBarTitle: StringsHelper.updateProfile,
      builder:
          (
            ctx,
            lastNameController,
            phoneNumberController,
            cnpController,
            firstNameController,
          ) => [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.29),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomButton(
                text: StringsHelper.update,
                // icon: Icons.arrow_forward_ios,
                onPressed: () async {
                  try {
                    var profile = PatientProfile(
                      lastName: lastNameController.text,
                      phoneNumber: phoneNumberController.text,
                      cnp: cnpController.text,
                      firstName: firstNameController.text,
                    );
                    var resp = await _service.completeProfile(profile);
                    if (resp.statusCode == 200) {
                      navigator.pop();
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButton(
                text: "Log out",
                backgroundColor: ColorsHelper.mainRed,
                onPressed: () async {
                  await AuthManager().reset();
                  await navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => OnboardingScreen()),
                    (_) => true,
                  );
                },
              ),
            ),
          ],
    );
  }
}
