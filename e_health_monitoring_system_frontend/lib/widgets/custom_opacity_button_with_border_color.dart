import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class CustomOpacityButtonWithBorderColor extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color backgroundColor;
  final IconData? icon;

  const CustomOpacityButtonWithBorderColor({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = ColorsHelper.mainPurple,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 55,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor.withOpacity(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: backgroundColor),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: backgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null)
                Positioned(
                  right: 5,
                  child: Icon(icon, color: backgroundColor, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
