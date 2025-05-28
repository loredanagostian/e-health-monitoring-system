import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/widgets_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/appointment_api_model.dart';
import 'package:e_health_monitoring_system_frontend/models/doctor_profile.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/book_appoinment_final_details_screen.dart';
import 'package:e_health_monitoring_system_frontend/services/appointment_service.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/info_tag.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentTimeSlotScreen extends StatefulWidget {
  final DoctorProfile doctor;
  const BookAppointmentTimeSlotScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentTimeSlotScreen> createState() =>
      _BookAppointmentTimeSlotScreenState();
}

class _BookAppointmentTimeSlotScreenState
    extends State<BookAppointmentTimeSlotScreen> {
  String? selectedTime;
  String? selectedDay;

  void onTimeSelected(String time, String day) {
    setState(() {
      selectedTime = time;
      selectedDay = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.bookAppointment,
        implyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorCard(
                  doctorName: widget.doctor.name,
                  doctorSpecialization:
                      widget.doctor.specializations.isNotEmpty
                          ? widget.doctor.specializations
                          : ["N/A"],
                  detailsList: [],
                  doctorPhotoPath: ImageHelper.fixImageUrl(
                    widget.doctor.picture,
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(7, (index) {
                    final currentDay = DateTime.now().add(
                      Duration(days: index),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: getDaySchedule(currentDay),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border.all(color: ColorsHelper.lightGray),
        ),
        child: SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: StringsHelper.bookNow,
            icon: Icons.arrow_forward_ios,
            backgroundColor:
                selectedTime == null
                    ? ColorsHelper.mediumGray
                    : ColorsHelper.mainPurple,
            onPressed:
                selectedTime != null && selectedDay != null
                    ? () async {
                      final contextRef = context;

                      try {
                        final fullDateTime = DateFormat(
                          'EEEE, dd MMMM HH:mm',
                        ).parse("$selectedDay $selectedTime");

                        final appointment = AppointmentApiModel(
                          appointmentTypeId:
                              "", // TODO: doctor appointment type ID
                          date: fullDateTime.toUtc().toIso8601String(),
                          totalCost: 100, // TODO
                        );

                        final response = await AppointmentService()
                            .createAppointment(appointment);

                        if (response.statusCode == 200) {
                          if (!contextRef.mounted) return;
                          Navigator.push(
                            contextRef,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      BookAppointmentFinalDetailsScreen(
                                        doctorName: widget.doctor.name,
                                        date: selectedDay!,
                                        time: selectedTime!,
                                      ),
                            ),
                          );
                        } else {
                          WidgetsHelper.showCustomSnackBar(
                            message: "Failed to create appointment.",
                          );
                        }
                      } catch (e) {
                        WidgetsHelper.showCustomSnackBar(message: e.toString());
                      }
                    }
                    : null,
          ),
        ),
      ),
    );
  }

  Widget getDaySchedule(DateTime day) {
    final String dayLabel = DateFormat('EEEE, dd MMMM').format(day);

    final List<String> times = ["08:00", "10:00", "12:00", "14:00", "16:00"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(dayLabel, style: StylesHelper.titleStyle),
        SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
          physics: NeverScrollableScrollPhysics(),
          childAspectRatio: 3,
          children:
              times.map((time) {
                return GestureDetector(
                  onTap: () => onTimeSelected(time, dayLabel),
                  child: InfoTag(
                    infoText: time,
                    isSelected: selectedTime == time && selectedDay == dayLabel,
                    centerText: true,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
