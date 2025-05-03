import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/widgets.dart';

class InfoTag extends StatelessWidget {
  final String infoText;
  final Function()? onPressed;

  const InfoTag({
    super.key,
    this.infoText = StringsHelper.viewAll,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          border: Border.all(color: ColorsHelper.mediumGray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          infoText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: ColorsHelper.darkGray,
          ),
        ),
      ),
    );
  }
}
