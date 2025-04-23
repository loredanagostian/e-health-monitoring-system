import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = ColorsHelper.mainPurple,
    this.textColor = ColorsHelper.mainWhite,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 55,
        width: 300,
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          ),
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (icon != null)
                Positioned(
                  right: 5,
                  child: Icon(
                    icon,
                    color: textColor,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
