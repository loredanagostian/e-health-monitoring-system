import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/analysis_report.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:flutter/material.dart';

class AnalysisReportsScreen extends StatelessWidget {
  const AnalysisReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.analysisReports,
        implyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                AnalysisReport(
                  reportId: "31231245",
                  detailsList: [
                    CustomRowIconText(
                      icon: Icons.history,
                      text: "26 July 2024, 12:00",
                    ),
                    CustomRowIconText(
                      icon: Icons.medical_information_outlined,
                      text: "Dr. Lorem Ipsum",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
