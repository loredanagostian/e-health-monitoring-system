import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/doctor_profile.dart';
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
      body: FutureBuilder(
        future: AppointmentService.getBookedTimeSlots(widget.doctor.id),
        builder:
            (ctx, snapshot) => SingleChildScrollView(
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
                            child: getDaySchedule(
                              currentDay,
                              snapshot.data ?? [],
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
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
                    ? () => navigator.push(
                      MaterialPageRoute(
                        builder:
                            (context) => BookAppointmentFinalDetailsScreen(
                              doctorName: widget.doctor.name,
                              date: selectedDay!,
                              time: selectedTime!,
                            ),
                      ),
                    )
                    : null,
          ),
        ),
      ),
    );
  }

  Widget getDaySchedule(DateTime day, List<DateTime> bookedSlots) {
    final bookedSlotsToday =
        bookedSlots.where((s) => s.day == day.day).map((s) => s.hour).toSet();
    final numberFormat = NumberFormat("00");
    final String dayLabel = DateFormat('EEEE, dd MMMM').format(day);

    final times = [8, 10, 12, 14, 16];

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
              times
                  .where((t) => !bookedSlotsToday.contains(t))
                  .map((t) => "${numberFormat.format(t)}:00")
                  .map((time) {
                    return GestureDetector(
                      onTap: () => onTimeSelected(time, dayLabel),
                      child: InfoTag(
                        infoText: time,
                        isSelected:
                            selectedTime == time && selectedDay == dayLabel,
                        centerText: true,
                      ),
                    );
                  })
                  .toList(),
        ),
      ],
    );
  }
}
