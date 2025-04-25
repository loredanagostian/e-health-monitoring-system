import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:flutter/material.dart';

class AnalysisReport extends StatelessWidget {
  final String reportId;
  final List<Widget> detailsList;
  const AnalysisReport({
    super.key,
    required this.reportId,
    required this.detailsList,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: implement download
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsHelper.mediumGray),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.bloodtype_outlined,
                  size: 40,
                  color: ColorsHelper.mainDark,
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      StringsHelper.testReport,
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorsHelper.mainDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      reportId,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorsHelper.darkGray,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.file_download_outlined,
                    size: 24,
                    color: ColorsHelper.mainDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            ...detailsList,
          ],
        ),
      ),
    );
  }
}
