import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class CustomSnackbarContent extends StatelessWidget {
  final String snackBarMessage;
  const CustomSnackbarContent({super.key, required this.snackBarMessage});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          const Icon(Icons.priority_high, color: ColorsHelper.mainWhite),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              snackBarMessage,
              style: TextStyle(
                color: ColorsHelper.mainWhite,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
