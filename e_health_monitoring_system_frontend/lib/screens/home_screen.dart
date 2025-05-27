import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/book_now_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_row_icon_string.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_report.dart';
import 'package:e_health_monitoring_system_frontend/widgets/upcoming_appointment.dart';
import 'package:e_health_monitoring_system_frontend/widgets/info_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool hasNotifications = true;
  String? firstName;
  String? lastName;
  static final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final _firstname = await _prefs.getString('firstName');
    final _lastname = await _prefs.getString('lastName');

    setState(() {
      firstName = _firstname;
      lastName = _lastname;
    });
  }

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
          backgroundColor: ColorsHelper.mainWhite,
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: ColorsHelper.mediumPurple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "${(firstName?.isNotEmpty ?? false ? firstName![0] : '')}${(lastName?.isNotEmpty ?? false ? lastName![0] : '')}",
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
                "$firstName $lastName",
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
                  doctorSpecialization: [], // TODO
                  doctorPhotoPath: 'assets/images/mockup_doctor.png',
                  detailsList: [
                    CustomRowIconText(
                      icon: Icons.history,
                      text: "26 July 2024, 12:00",
                    ),
                    BookNowButton(onPressed: () {}),
                  ],
                  width: 340,
                  hasVisibleIcons: true,
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: DoctorCard(
                  doctorName: "Dr. Lorem Ipsum",
                  doctorSpecialization: [], // TODO
                  doctorPhotoPath: 'assets/images/mockup_doctor.png',
                  detailsList: [
                    CustomRowIconText(
                      icon: Icons.history,
                      text: "26 July 2024, 12:00",
                    ),
                    BookNowButton(onPressed: () {}),
                  ],
                  width: 340,
                  hasVisibleIcons: true,
                  onPressed: () {},
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
          Text(title, style: StylesHelper.titleStyle),
          Visibility(
            visible: isViewAllButtonVisible,
            child: InfoTag(onPressed: () {}), // TODO: add navigation
          ),
        ],
      ),
    );
  }
}
