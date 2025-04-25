import 'package:e_health_monitoring_system_frontend/helpers/assets_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_report.dart';
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getUpcomingAppointments(),
                SizedBox(height: 15),
                getRecentVisits(),
                SizedBox(height: 15),
                getMedicalReports(),
              ],
            ),
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
      children: [
        getSectionTitle(
          StringsHelper.upcomingAppointments,
          isViewAllButtonVisible: true,
        ),
      ],
    );
  }

  Widget getRecentVisits() {
    return Column(
      children: [
        getSectionTitle(
          StringsHelper.recentVisits,
          isViewAllButtonVisible: true,
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
        Row(
          children: [
            MedicalReport(medicalReportType: MedicalReportType.examinations),
            SizedBox(width: 20),
            MedicalReport(medicalReportType: MedicalReportType.analysis),
          ],
        ),
      ],
    );
  }

  Widget getSectionTitle(String title, {bool isViewAllButtonVisible = false}) {
    return Row(
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
