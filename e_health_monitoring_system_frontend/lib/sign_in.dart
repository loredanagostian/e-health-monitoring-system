import 'package:e_health_monitoring_system_frontend/sign_up.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Placeholder(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () {}, child: Text("Sign In")),
              ),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.labelLarge,
                  text: "Not a user yet? ",
                  children: <TextSpan>[
                    TextSpan(
                      text: "Sign up!",
                      style: TextStyle(color: theme.colorScheme.primary),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
