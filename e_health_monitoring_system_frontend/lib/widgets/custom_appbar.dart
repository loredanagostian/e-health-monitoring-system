import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final bool implyLeading;
  const CustomAppbar({
    super.key,
    required this.appBarTitle,
    this.implyLeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: implyLeading,
      leading:
          implyLeading
              ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: ColorsHelper.mainDark,
                ),
                onPressed: () => navigator.pop(),
              )
              : null,
      title: Text(
        appBarTitle,
        style: TextStyle(
          fontSize: 20,
          color: ColorsHelper.mainDark,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
