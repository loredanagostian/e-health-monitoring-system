import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/widgets.dart';

class ViewAllButton extends StatelessWidget {
  final Function() onPressed;

  const ViewAllButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          border: Border.all(color: ColorsHelper.mediumGray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            StringsHelper.viewAll,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorsHelper.darkGray,
            ),
          ),
        ),
      ),
    );
  }
}
