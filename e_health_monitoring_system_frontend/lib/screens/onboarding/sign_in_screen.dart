import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/home_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/forgot_password_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_up_screen.dart';
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
                        ref
                            .read(bottomNavigatorIndex.notifier)
                            .update((state) => 1);
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    const HomeScreen(), // TODO: redirect to home page
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
    // AuthenticationManager authManager = AuthenticationManager();
    String message = '';

    if (email.isNotEmpty && password.isNotEmpty) {
      if (RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
      ).hasMatch(email)) {
        // message = await authManager.logInUser(email, password);
        if (message == '') {
          return true;
        } else {
          WidgetsHelper.showCustomSnackBar(message: message);
        }
      } else {
        WidgetsHelper.showCustomSnackBar(message: StringsHelper.invalidEmail);
      }
    } else {
      WidgetsHelper.showCustomSnackBar(
        message: StringsHelper.allFieldsMustBeCompleted,
      );
    }

    return false;
  }
}
