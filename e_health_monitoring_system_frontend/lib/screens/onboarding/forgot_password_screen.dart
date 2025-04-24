import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/fields_validation_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool pressedResetButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.forgotPasswordTitle,
        implyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      !pressedResetButton
                          ? StringsHelper.enterEmailBelow
                          : StringsHelper.checkYourInbox,
                      style: TextStyle(
                        color: ColorsHelper.darkGray,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 5),
                    Visibility(
                      visible: pressedResetButton,
                      child: Text(
                        emailController.text,
                        style: TextStyle(
                          color: ColorsHelper.mainDark,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!pressedResetButton) ...[
                  SizedBox(height: 20),
                  CustomTextField(
                    textFieldType: TextFieldType.email,
                    controller: emailController,
                  ),
                  SizedBox(height: 530),
                ],

                if (pressedResetButton) ...[
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 180),
                        Image.asset(
                          AssetsHelper.successIcon,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 20),
                        Text(
                          StringsHelper.emailSentSuccessfully,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsHelper.mainDark,
                          ),
                        ),
                        SizedBox(height: 300),
                      ],
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomButton(
                    text:
                        !pressedResetButton
                            ? StringsHelper.resetPassword
                            : StringsHelper.signIn,
                    icon: !pressedResetButton ? null : Icons.arrow_forward_ios,
                    onPressed:
                        () =>
                            !pressedResetButton
                                ? validateFields(emailController.text)
                                : navigator.pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void validateFields(String email) {
    var isEmailValid = FieldsValidationHelper.validateEmail(email);

    if (email.isNotEmpty && isEmailValid) {
      // TODO: add BE check for email
      setState(() {
        pressedResetButton = true;
      });
    } else {
      String errorMessage = "";

      if (email.isEmpty) {
        errorMessage = StringsHelper.allFieldsMustBeCompleted;
      } else if (!isEmailValid) {
        errorMessage = StringsHelper.emailFormatIsNotValid;
      }

      WidgetsHelper.showCustomSnackBar(message: errorMessage);
    }
  }
}
