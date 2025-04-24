import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/fields_validation_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_in_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/verify_email_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/register_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  static const _registerService = RegisterService();

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 75),
                Image.asset(
                  AssetsHelper.appLogo,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),
                Text(
                  StringsHelper.signUp,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsHelper.mainDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  textFieldType: TextFieldType.email,
                  controller: emailController,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.password,
                  controller: passwordController,
                ),
                CustomTextField(
                  textFieldType: TextFieldType.confirmPassword,
                  controller: confirmPasswordController,
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    text: StringsHelper.signUp,
                    icon: Icons.arrow_forward_ios,
                    onPressed:
                        () => validateFields(
                          emailController.text,
                          passwordController.text,
                          confirmPasswordController.text,
                        ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringsHelper.alreadyUser,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorsHelper.mainDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        navigator.pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: Text(
                        StringsHelper.signIn,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ColorsHelper.mainPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void singUp() async {
    var resp = await SignUpScreen._registerService.signUpPatient(
      PatientRegister(
        email: emailController.text,
        passwd: passwordController.text,
      ),
    );

    if (resp.statusCode != 201) {
      var body = jsonDecode(resp.body);
      WidgetsHelper.showCustomSnackBar(message: body['msg']);
    } else {
      String userId = jsonDecode(resp.body)['userId'];
      navigator.push(
        MaterialPageRoute(
          builder:
              (_) => VerifyEmailScreen(
                userId: userId,
                userEmail: emailController.text,
              ),
        ),
      );
    }
  }

  Future<String> validateFields(
    String email,
    String password,
    String confirmPassword,
  ) async {
    var isEmailValid = FieldsValidationHelper.validateEmail(email);
    var passwordValidationMessage = FieldsValidationHelper.validatePassword(
      password,
    );

    if (email.isNotEmpty &&
        isEmailValid &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        passwordValidationMessage.isEmpty) {
      singUp();
    } else {
      String errorMessage = "";

      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        errorMessage = StringsHelper.allFieldsMustBeCompleted;
      } else if (password != confirmPassword) {
        errorMessage = StringsHelper.passwordsShouldMatch;
      } else if (passwordValidationMessage.isNotEmpty) {
        errorMessage = passwordValidationMessage;
      } else if (!isEmailValid) {
        errorMessage = StringsHelper.emailFormatIsNotValid;
      } else {
        errorMessage = StringsHelper.invalidCredentials;
      }

      WidgetsHelper.showCustomSnackBar(message: errorMessage);
    }

    return '';
  }
}
