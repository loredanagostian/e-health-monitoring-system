import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/auth_manager.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/fields_validation_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/jwt_token.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:e_health_monitoring_system_frontend/screens/home_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/forgot_password_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_up_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/register_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  StringsHelper.signIn,
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
                GestureDetector(
                  onTap:
                      () => navigator.push(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 17),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        StringsHelper.forgotPassword,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: ColorsHelper.darkGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.33),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    text: StringsHelper.signIn,
                    icon: Icons.arrow_forward_ios,
                    onPressed: () async {
                      bool shouldLogin = await validateFields(
                        emailController.text,
                        passwordController.text,
                      );

                      if (shouldLogin) {
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringsHelper.notUserYet,
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
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        StringsHelper.signUp,
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

  Future<bool> validateFields(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      WidgetsHelper.showCustomSnackBar(
        message: StringsHelper.allFieldsMustBeCompleted,
      );
      return false;
    }

    if (!FieldsValidationHelper.validateEmail(email)) {
      WidgetsHelper.showCustomSnackBar(message: StringsHelper.invalidEmail);
      return false;
    }

    var passwdErr = FieldsValidationHelper.validatePassword(password);
    if (passwdErr.isNotEmpty) {
      WidgetsHelper.showCustomSnackBar(message: passwdErr);
      return false;
    }

    var service = RegisterService();
    var authManger = AuthManager();
    var resp = await service.singInPatient(
      PatientRegister(email: email, passwd: password),
    );

    var body = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      await authManger.saveToken(JwtToken.fromJson(body['token']));
      return true;
    }

    WidgetsHelper.showCustomSnackBar(message: body['msg']);
    return false;
  }
}
