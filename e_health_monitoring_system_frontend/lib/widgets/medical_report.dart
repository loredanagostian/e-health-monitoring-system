import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/analysis_reports_screen.dart';
import 'package:e_health_monitoring_system_frontend/screens/examination_reports_screen.dart';
import 'package:flutter/material.dart';

enum MedicalReportType { examinations, analysis }

class MedicalReport extends StatelessWidget {
  final MedicalReportType medicalReportType;
  const MedicalReport({super.key, required this.medicalReportType});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => navigator.push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      medicalReportType == MedicalReportType.analysis
                          ? AnalysisReportsScreen()
                          : ExaminationReportsScreen(),
            ),
          ),
      child: Container(
        height: 140,
        width: 115,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsHelper.mediumGray),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              medicalReportType == MedicalReportType.examinations
                  ? AssetsHelper.examinationsIcon
                  : AssetsHelper.analysisIcon,
              height: 75,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 10),
            Text(
              medicalReportType == MedicalReportType.examinations
                  ? StringsHelper.examinations
                  : StringsHelper.analysis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorsHelper.mainDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
