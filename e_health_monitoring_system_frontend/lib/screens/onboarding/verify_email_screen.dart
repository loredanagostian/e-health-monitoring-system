import 'dart:convert';

import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/onboarding/complete_profile_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/register_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

enum EmailStatus { confirmed, unconfirmed, internalError }

class ConfirmEmailNotifier extends ChangeNotifier {
  ConfirmEmailNotifier(this._userId);
  final String _userId;

  final _service = const RegisterService();
  EmailStatus status = EmailStatus.unconfirmed;

  void checkEmail() async {
    final maxDuration = Duration(minutes: 2);
    final pollInterval = Duration(seconds: 5);
    final startTime = DateTime.now();

    while (status == EmailStatus.unconfirmed && hasListeners) {
      if (DateTime.now().difference(startTime) > maxDuration) {
        status = EmailStatus.internalError;
        notifyListeners();
        break;
      }

      await Future.delayed(pollInterval);

      if (!hasListeners) break;

      try {
        var resp = await _service.checkEmailConfirmed(_userId);
        var body = jsonDecode(resp.body);

        if (body case {"isEmailConfirmed": bool isConfirmed}) {
          if (isConfirmed) {
            status = EmailStatus.confirmed;
          }
        } else {
          status = EmailStatus.internalError;
        }
      } catch (e) {
        status = EmailStatus.internalError;
      }

      if (hasListeners) notifyListeners();
    }
  }
}

class VerifyEmailScreen extends StatelessWidget {
  final String userId;
  final String userEmail;

  const VerifyEmailScreen({
    super.key,
    required this.userId,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfirmEmailNotifier(userId),
      child: Scaffold(
        appBar: CustomAppbar(appBarTitle: StringsHelper.verifyEmail),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringsHelper.verifyEmailMessage,
                  style: TextStyle(color: ColorsHelper.darkGray, fontSize: 16),
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: ColorsHelper.mainDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 150),
                Center(
                  child: Consumer<ConfirmEmailNotifier>(
                    builder: (context, notifier, child) {
                      switch (notifier.status) {
                        case EmailStatus.confirmed:
                          return confirmedStatusWiget();
                        case EmailStatus.unconfirmed:
                          notifier.checkEmail();
                          return defaultStatusWidget();
                        case EmailStatus.internalError:
                          return errorStatusWidget();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmedStatusWiget() {
    return Column(
      children: [
        Image.asset(AssetsHelper.successIcon, height: 100, fit: BoxFit.contain),
        SizedBox(height: 20),
        Text(
          StringsHelper.emailVerified,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsHelper.mainDark,
          ),
        ),
        SizedBox(height: 5),
        Text(
          StringsHelper.emailVerifiedMessage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: ColorsHelper.mainDark,
          ),
        ),
        SizedBox(height: 300),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomButton(
            text: StringsHelper.continueText,
            icon: Icons.arrow_forward_ios,
            onPressed:
                () => navigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => CompleteProfileScreen(),
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget defaultStatusWidget() {
    return Column(
      children: [
        Lottie.asset(AssetsHelper.loadingSpinner, width: 150),
        SizedBox(height: 25),
        Text(
          StringsHelper.verifyingEmail,
          style: TextStyle(
            color: ColorsHelper.mainDark,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget errorStatusWidget() {
    return Column(
      children: [
        Image.asset(AssetsHelper.errorIcon, height: 100, fit: BoxFit.contain),
        SizedBox(height: 20),
        Text(
          StringsHelper.emailCouldntBeVerified,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorsHelper.mainDark,
          ),
        ),
        SizedBox(height: 5),
        Text(
          StringsHelper.emailCouldntBeVerifiedMessage,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: ColorsHelper.mainDark,
          ),
        ),
        SizedBox(height: 300),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CustomButton(
            text: StringsHelper.resend,
            // TODO: integrate Re-send BE
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
