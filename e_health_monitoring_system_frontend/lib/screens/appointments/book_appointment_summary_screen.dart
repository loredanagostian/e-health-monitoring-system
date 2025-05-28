import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/doctor_profile.dart';
import 'package:e_health_monitoring_system_frontend/screens/main_screen.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_opacity_button_with_border_color.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/price_tile.dart';
import 'package:flutter/material.dart';

class BookAppointmentSummaryScreen extends StatelessWidget {
  final DoctorProfile doctor;
  final String date;
  final String time;
  final String reasonToVisit;
  final String totalCost;
  final bool isSuccess;
  const BookAppointmentSummaryScreen({
    super.key,
    required this.doctor,
    required this.reasonToVisit,
    required this.totalCost,
    required this.date,
    required this.time,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.bookAppointment,
        implyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child:
              isSuccess
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorCard(
                        doctorName: doctor.name,
                        doctorSpecialization:
                            doctor.specializations.isNotEmpty
                                ? doctor.specializations
                                : ["N/A"],
                        detailsList: [
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 20,
                                    color: ColorsHelper.mainPurple,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    date,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorsHelper.mainPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.schedule_outlined,
                                    size: 20,
                                    color: ColorsHelper.mainPurple,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ColorsHelper.mainPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                        doctorPhotoPath:
                            doctor.picture.isNotEmpty
                                ? ImageHelper.fixImageUrl(doctor.picture)
                                : "/assets/images/mockup_doctor.png",
                      ),
                      SizedBox(height: 30),
                      getReasonToVisit(),
                      SizedBox(height: 30),
                      getTotalCost(),
                      Spacer(),
                      CustomButton(
                        text: StringsHelper.goToHomePage,
                        icon: Icons.arrow_forward_ios,
                        backgroundColor: ColorsHelper.mainPurple,
                        onPressed:
                            () => navigator.pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        MainScreen(bottomNavigatorIndex: 1),
                              ),
                              (route) => false,
                            ),
                      ),
                      SizedBox(height: 20),
                      CustomOpacityButtonWithBorderColor(
                        text: StringsHelper.cancel,
                        backgroundColor: ColorsHelper.mainRed,
                        // TODO: implement
                        onPressed: () {},
                      ),
                    ],
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.asset(AssetsHelper.errorIcon, height: 105),
                      SizedBox(height: 15),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 200),
                        child: Text(
                          StringsHelper.appointmentBookedError,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorsHelper.mainDark,
                          ),
                        ),
                      ),
                      Spacer(),
                      CustomButton(
                        text: StringsHelper.goToHomePage,
                        icon: Icons.arrow_forward_ios,
                        backgroundColor: ColorsHelper.mainPurple,
                        onPressed: () {
                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MainScreen(bottomNavigatorIndex: 1),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget getReasonToVisit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.reasonToVisit, style: StylesHelper.titleStyle),
        SizedBox(height: 15),
        PriceTile(consultationType: reasonToVisit, price: ""),
      ],
    );
  }

  Widget getTotalCost() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(StringsHelper.totalCost, style: StylesHelper.titleStyle),
        Spacer(),
        Text(
          totalCost,
          style: TextStyle(fontSize: 16, color: ColorsHelper.mainDark),
        ),
      ],
    );
  }
}
