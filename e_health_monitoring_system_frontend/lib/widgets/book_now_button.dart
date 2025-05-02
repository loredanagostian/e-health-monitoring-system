import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';

class BookNowButton extends StatelessWidget {
  final Function() onPressed;
  const BookNowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: ColorsHelper.mainPurple,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 20,
            color: ColorsHelper.mainWhite,
          ),
          SizedBox(width: 5),
          Text(
            StringsHelper.bookNow,
            style: TextStyle(color: ColorsHelper.mainWhite, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
