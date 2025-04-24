import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/sign_in_screen.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                // Full width layout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsHelper.onboardingImage,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 60),
                      Text(
                        StringsHelper.onboardingTitle,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ColorsHelper.mainDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        StringsHelper.onboardingMessage,
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorsHelper.mediumGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.12,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: CustomButton(
                          text: StringsHelper.getStarted,
                          icon: Icons.arrow_forward_ios,
                          onPressed: () {
                            navigator.pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
