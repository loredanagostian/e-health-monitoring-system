import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/confirm_email.dart';
import 'package:e_health_monitoring_system_frontend/services/register_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/email_field.dart';
import 'package:e_health_monitoring_system_frontend/widgets/floating_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  static const _registerService = RegisterService();
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var emailController = TextEditingController();
    var passwdController = TextEditingController();
    var confirmPasswdController = TextEditingController();
    var navigator = Navigator.of(context);
    var messenger = ScaffoldMessenger.of(context);

    void singUp() async {
      if (_formKey.currentState!.validate()) {
        var resp = await SignUp._registerService.signUpPatient(
          PatientRegister(
            email: emailController.text,
            passwd: passwdController.text,
          ),
        );
        if (resp.statusCode != 201) {
          var body = jsonDecode(resp.body);
          messenger.showSnackBar(SnackBar(content: Text(body['msg'])));
        } else {
          String userId = jsonDecode(resp.body)['userId'];
          navigator.push(
            MaterialPageRoute(builder: (_) => ConfirmEmailScreen(userId)),
          );
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingButton(
          onPressed: singUp,
          label: "Sing Up!",
          children: [
            RichText(
              text: TextSpan(
                style: theme.textTheme.labelLarge,
                text: "Already a user? ",
                children: <TextSpan>[
                  TextSpan(
                    text: "Sign in!",
                    style: TextStyle(color: ColorsHelper.mainPurple),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pop();
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Column(
                children: [
                  Image.asset(AssetsHelper.registerIcon, height: 250),
                  EmailField(controller: emailController),
                  SizedBox(height: 30),
                  PasswdTextField(
                    controller: passwdController,
                    hintText: "Enter your password",
                    validator: (value) {
                      if (passwdController.text !=
                          confirmPasswdController.text) {
                        return "Passwords do not match.";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  PasswdTextField(
                    controller: confirmPasswdController,
                    hintText: "Confirm your password",
                    prefixIcon: Icons.check_circle_outlined,
                    validator: (value) {
                      if (passwdController.text !=
                          confirmPasswdController.text) {
                        return "Passwords do not match.";
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
