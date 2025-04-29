import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class CustomRowIconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const CustomRowIconText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: ColorsHelper.mediumGray),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(color: ColorsHelper.mediumGray, fontSize: 14),
        ),
      ],
    );
  }
}
