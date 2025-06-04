import 'package:e_health_monitoring_system_frontend/helpers/date_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/upcoming_appointment_dto.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/appointment_details_screen.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:flutter/material.dart';

class AppointmentsListScreen extends StatelessWidget {
  final bool isUpcoming;
  final List<AppointmentDto> appointments;
  const AppointmentsListScreen({
    required this.isUpcoming,
    required this.appointments,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle:
            isUpcoming
                ? StringsHelper.upcomingAppointments
                : StringsHelper.recentVisits,
        implyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              children:
                  appointments
                      .map(
                        (ap) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: DoctorCard(
                            doctorName: ap.doctorName,
                            doctorSpecialization: [],
                            doctorPhotoPath: ap.doctorPicture,
                            detailsList: [
                              CustomRowIconText(
                                icon: Icons.history,
                                text:
                                    "${DateHelper.formatDate(ap.date)} ${DateHelper.formatTime(ap.date)}",
                              ),
                              CustomRowIconText(
                                icon: Icons.medical_information_outlined,
                                text: ap.appointmentType,
                              ),
                            ],
                            hasVisibleIcons: true,
                            onPressed:
                                () => navigator.push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => AppointmentDetailsScreen(
                                          isUpcoming: isUpcoming,
                                          appointmentId: ap.id,
                                          medicalHistory: ap.medicalHistory,
                                        ),
                                  ),
                                ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
