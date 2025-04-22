import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_in.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset(AssetsHelper.onboardingImage),
                SizedBox(height: 60),
                Text(
                  StringsHelper.onboardingTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: ColorsHelper.mainDark,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  StringsHelper.onboardingMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsHelper.lightGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CustomButton(
                text: StringsHelper.getStarted,
                icon: Icons.arrow_forward_ios,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
