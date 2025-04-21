import 'package:flutter/material.dart';
import 'package:e_health_monitoring_system_frontend/sign_in.dart';

// TODO: use string constants
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: if user is logged in diplay other page
    return const MaterialApp(
      home: Scaffold(body: SafeArea(child: GetStartedPage())),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Placeholder(),
            SizedBox(height: 30),
            Text(
              "Your Health App",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              "Digital healthcare platform - secure patient records, online appointment booking, e-prescriptions, and treatment monitoring",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                autofocus: true,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
