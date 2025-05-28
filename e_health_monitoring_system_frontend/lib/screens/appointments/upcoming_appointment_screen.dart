import 'package:e_health_monitoring_system_frontend/helpers/date_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/book_appointment_time_slot.dart';
import 'package:e_health_monitoring_system_frontend/services/appointment_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final String appointmentId;
  const AppointmentDetailsScreen({super.key, required this.appointmentId});

  @override
  State<AppointmentDetailsScreen> createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: AppointmentService.getAppointmentDetails(widget.appointmentId),
      builder:
          (ctx, snapshot) => Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(25.0),
              child: CustomButton(
                text: "Book again",
                icon: Icons.calendar_month,
                onPressed: () async {
                  // navigator.push(
                  //   MaterialPageRoute(
                  //     builder:
                  //         (_) => BookAppointmentTimeSlotScreen(doctor: doctor),
                  //   ),
                  // );
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBar: CustomAppbar(
              appBarTitle: StringsHelper.upcomingAppointment,
              implyLeading: true,
            ),
            body:
                snapshot.hasData
                    ? SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DoctorCard(
                              doctorName: snapshot.data!.doctorName,
                              doctorSpecialization: [],
                              detailsList: [
                                CustomRowIconText(
                                  icon: Icons.history,
                                  text:
                                      "${DateHelper.formatDate(snapshot.data!.date)} ${DateHelper.formatTime(snapshot.data!.date)}",
                                ),
                                CustomRowIconText(
                                  icon: Icons.medical_information_outlined,
                                  text: snapshot.data!.appointmentType,
                                ),
                              ],
                              doctorPhotoPath: snapshot.data!.doctorPicture,
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total cost",
                                  style: StylesHelper.titleStyle,
                                ),
                                Text(
                                  "${snapshot.data!.totalCost} RON",
                                  style: StylesHelper.titleStyle,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Medical history",
                              style: StylesHelper.titleStyle,
                            ),
                            Text(snapshot.data!.medicalHistory),
                            SizedBox(height: 20),
                            Text("Diagnostic", style: StylesHelper.titleStyle),
                            Text(snapshot.data!.diagnostic),
                            SizedBox(height: 20),
                            Text(
                              "Recommendations",
                              style: StylesHelper.titleStyle,
                            ),
                            Text(snapshot.data!.recommendation),
                          ],
                        ),
                      ),
                    )
                    : Placeholder(),
          ),
    );
  }
}
