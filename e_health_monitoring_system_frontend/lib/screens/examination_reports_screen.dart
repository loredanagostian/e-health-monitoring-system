import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:flutter/material.dart';

class ExaminationReportsScreen extends StatelessWidget {
  const ExaminationReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.examinationReports,
        implyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                DoctorCard(
                  doctorName: "Dr. Lorem Ipsum",
                  doctorSpecialization: "Dentist",
                  doctorPhotoPath: 'assets/images/mockup_doctor.png',
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
                  hasVisibleIcons: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
