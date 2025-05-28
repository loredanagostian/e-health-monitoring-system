import 'package:e_health_monitoring_system_frontend/helpers/date_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/upcoming_appointment_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/appointment_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingAppointmentsScreen extends StatelessWidget {
  const UpcomingAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.upcomingAppointments,
        implyLeading: true,
      ),
      body: FutureBuilder(
        future: AppointmentService.getUpcomingAppointments(),
        builder:
            (ctx, snapshot) => SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children:
                        (snapshot.data ?? [])
                            .map(
                              (ap) => DoctorCard(
                                doctorName: ap.doctorName,
                                doctorSpecialization: [], // TODO
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
                                hasVisibleIcons: false,
                                onPressed:
                                    () => navigator.push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => AppointmentDetailsScreen(
                                              appointmentId: ap.id,
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
      ),
    );
  }
}
