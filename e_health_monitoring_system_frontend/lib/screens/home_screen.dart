import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_report.dart';
import 'package:e_health_monitoring_system_frontend/widgets/upcoming_appointment.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getUpcomingAppointments(),
              SizedBox(height: 30),
              getRecentVisits(),
              SizedBox(height: 30),
              getMedicalReports(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight + 40),
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        child: AppBar(
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ColorsHelper.mainPurple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "LG",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: ColorsHelper.mainWhite,
                ),
              ),
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${StringsHelper.hi},",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: ColorsHelper.darkGray,
                ),
              ),
              Text(
                "Loredana Gostian",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsHelper.mainDark,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              // TODO: navigate to NotificationScreen
              onTap: () {},
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      hasNotifications
                          ? ColorsHelper.lightPurple
                          : ColorsHelper.lightGray,
                  border: Border.all(
                    color:
                        hasNotifications
                            ? ColorsHelper.mainPurple
                            : ColorsHelper.mediumGray,
                  ),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  size: 25,
                  color:
                      hasNotifications
                          ? ColorsHelper.mainPurple
                          : ColorsHelper.mediumGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getUpcomingAppointments() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSectionTitle(
          StringsHelper.upcomingAppointments,
          isViewAllButtonVisible: true,
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: UpcomingAppointment(
                  doctorName: "Dr. Lorem Ipsum",
                  appointmentName: "Dermatology consultation",
                  date: "Saturday, 26 September",
                  time: "09:00",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: UpcomingAppointment(
                  doctorName: "Dr. Lorem Ipsum",
                  appointmentName: "Dermatology consultation",
                  date: "Saturday, 26 September",
                  time: "09:00",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getRecentVisits() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSectionTitle(
          StringsHelper.recentVisits,
          isViewAllButtonVisible: true,
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 25),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: DoctorCard(
                  doctorName: "Dr. Lorem Ipsum",
                  doctorSpecialization: "Dentist",
                  doctorPhotoPath: 'assets/images/mockup_doctor.png',
                  detailsList: [
                    CustomRowIconText(
                      icon: Icons.history,
                      text: "26 July 2024, 12:00",
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: ColorsHelper.mainPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: ColorsHelper.mainWhite,
                          ),
                          SizedBox(width: 5),
                          Text(
                            StringsHelper.bookNow,
                            style: TextStyle(
                              color: ColorsHelper.mainWhite,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  width: 340,
                  hasVisibleIcons: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: DoctorCard(
                  doctorName: "Dr. Lorem Ipsum",
                  doctorSpecialization: "Dentist",
                  doctorPhotoPath: 'assets/images/mockup_doctor.png',
                  detailsList: [
                    CustomRowIconText(
                      icon: Icons.history,
                      text: "26 July 2024, 12:00",
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: ColorsHelper.mainPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: ColorsHelper.mainWhite,
                          ),
                          SizedBox(width: 5),
                          Text(
                            StringsHelper.bookNow,
                            style: TextStyle(
                              color: ColorsHelper.mainWhite,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  width: 340,
                  hasVisibleIcons: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget getMedicalReports() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getSectionTitle(StringsHelper.medicalReports),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: [
              MedicalReport(medicalReportType: MedicalReportType.examinations),
              SizedBox(width: 20),
              MedicalReport(medicalReportType: MedicalReportType.analysis),
            ],
          ),
        ),
      ],
    );
  }

  Widget getSectionTitle(String title, {bool isViewAllButtonVisible = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ColorsHelper.mainDark,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Visibility(visible: isViewAllButtonVisible, child: viewAllButton()),
        ],
      ),
    );
  }

  Widget viewAllButton() {
    return GestureDetector(
      // TODO: add navigation
      onTap: () {},
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          border: Border.all(color: ColorsHelper.mediumGray),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            StringsHelper.viewAll,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: ColorsHelper.darkGray,
            ),
          ),
        ),
      ),
    );
  }
}
