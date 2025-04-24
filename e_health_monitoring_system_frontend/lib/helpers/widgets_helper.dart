import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_snackbar_content.dart';
import 'package:flutter/material.dart';

class WidgetsHelper {
  static void showCustomSnackBar({
    required String message,
    Color backgroundColor = ColorsHelper.mainRed,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: CustomSnackbarContent(snackBarMessage: message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(15),
      duration: duration,
    );

    rootScaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
