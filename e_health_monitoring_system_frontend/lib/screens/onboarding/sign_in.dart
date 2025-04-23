import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_up.dart';
import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:e_health_monitoring_system_frontend/services/register_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/email_field.dart';
import 'package:e_health_monitoring_system_frontend/widgets/floating_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/password_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// TODO: maybe use a single page for sing in/up
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var emailController = TextEditingController();
    var passwdController = TextEditingController();
    var registerService = RegisterService();
    var navigator = Navigator.of(context);
    var messenger = ScaffoldMessenger.of(context);

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await registerService
                  .singInPatient(
                    PatientRegister(
                      email: emailController.text,
                      passwd: passwdController.text,
                    ),
                  )
                  .then((response) {
                    if (response.statusCode != 200) {
                      var msg = jsonDecode(response.body)['msg'];
                      messenger.showSnackBar(SnackBar(content: Text(msg)));
                    } else {
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => Placeholder()),
                        (_) => false,
                      );
                    }
                  });
            }
          },
          label: "Sign in!",
          children: [
            RichText(
              text: TextSpan(
                style: theme.textTheme.labelLarge,
                text: "Not a user yet? ",
                children: <TextSpan>[
                  TextSpan(
                    text: "Sign up!",
                    style: TextStyle(color: ColorsHelper.mainPurple),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap =
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              ),
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
