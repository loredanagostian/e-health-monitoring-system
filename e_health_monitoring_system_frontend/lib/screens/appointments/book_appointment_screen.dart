import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/info_tag.dart';
import 'package:flutter/material.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorName;
  const BookAppointmentScreen({super.key, required this.doctorName});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  String? selectedTime;

  void onTimeSelected(String time) {
    setState(() {
      selectedTime = time;
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
                  doctorName: widget.doctorName,
                  doctorSpecialization: "Dentist",
                  detailsList: [
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.star,
                          color: ColorsHelper.mainYellow,
                          size: 25,
                        ),
                        Text(
                          "4.8/5 (31)",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                  doctorPhotoPath: "assets/images/mockup_doctor.png",
                ),
                SizedBox(height: 30),
                getDaySchedule("Monday, 26 July"),
                SizedBox(height: 30),
                getDaySchedule("Tuesday, 27 July"),
                SizedBox(height: 30),
                getDaySchedule("Wednesday, 28 July"),
                SizedBox(height: 30),
                getDaySchedule("Thursday, 29 July"),
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
                selectedTime != null
                    ? () {
                      // handle booking
                      print("Booked time: $selectedTime");
                    }
                    : null, // disable button when no time selected
          ),
        ),
      ),
    );
  }

  Widget getDaySchedule(String day) {
    final List<String> times = [
      "08:00",
      "09:00",
      "10:00",
      "11:00",
      "17:00",
      "18:00",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(day, style: StylesHelper.titleStyle),
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
                  onTap: () => onTimeSelected(time),
                  child: InfoTag(
                    infoText: time,
                    isSelected: selectedTime == time,
                    centerText: true,
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
