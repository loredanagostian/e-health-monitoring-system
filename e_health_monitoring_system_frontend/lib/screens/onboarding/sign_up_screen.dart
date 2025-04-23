import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/models/patient_register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var emailController = TextEditingController();
    var passwdController = TextEditingController();
    var confirmPasswdController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var newPatient = PatientRegister(
                      email: emailController.text,
                      passwd: passwdController.text,
                    );
                    var resp = await http.post(
                      headers: {"Content-Type": "application/json"},
                      Uri.parse("http://10.0.2.2:5200/api/PatientRegister"),
                      body: jsonEncode(newPatient.toJson()),
                    ).timeout(Duration(seconds: 10));
                    print("error ${resp.statusCode} ${resp.body}");
                  },
                  child: Text("Sign up"),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.labelLarge,
                  text: "Already a user? ",
                  children: <TextSpan>[
                    TextSpan(
                      text: "Sign in!",
                      style: TextStyle(color: theme.colorScheme.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pop();
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 105, width: 98, child: Placeholder()),
                SizedBox(height: 50),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(),
                    hintText: "Enter your email",
                  ),
                  controller: emailController,
                ),
                SizedBox(height: 50),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                    hintText: "Enter your password",
                  ),
                  obscureText: true,
                  autocorrect: false,
                  controller: passwdController,
                ),
                SizedBox(height: 50),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.check_circle),
                    border: OutlineInputBorder(),
                    hintText: "Confirm your password",
                  ),
                  obscureText: true,
                  autocorrect: false,
                  controller: confirmPasswdController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
