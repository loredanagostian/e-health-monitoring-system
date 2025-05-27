import 'package:e_health_monitoring_system_frontend/helpers/categories_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/widgets.dart';

class MedicalCategory extends StatefulWidget {
  final String categoryName;
  final bool isActive;
  final IconData? icon;

  const MedicalCategory({
    super.key,
    required this.categoryName,
    required this.isActive,
    this.icon,
  });

  @override
  State<MedicalCategory> createState() => _MedicalCategoryState();
}

class _MedicalCategoryState extends State<MedicalCategory> {
  late Color iconColor;
  late Color containerColor;

  @override
  Widget build(BuildContext context) {
    iconColor =
        widget.isActive ? ColorsHelper.mainPurple : ColorsHelper.darkGray;
    containerColor =
        widget.isActive ? ColorsHelper.lightPurple : ColorsHelper.lightGray;

    return Container(
      height: 130,
      width: 110,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorsHelper.mediumGray),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            widget.icon ?? medicalIcons[widget.categoryName],
            size: 30,
            color: iconColor,
          ),
          SizedBox(height: 5),
          Text(
            widget.categoryName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
