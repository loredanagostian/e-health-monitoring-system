import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/info_tag.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatelessWidget {
  final String doctorName;
  const DoctorProfileScreen({super.key, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appBarTitle: doctorName, implyLeading: true),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getDoctorPhotoCard(),
                      SizedBox(height: 30),
                      getDoctorSpecialization(),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                getSpecialistTags(),
                SizedBox(height: 20),
                getReviewsSection(),
                SizedBox(height: 20),
                getPrices(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getDoctorPhotoCard() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 350),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: double.infinity,
          height: 200,
          color: ColorsHelper.mainPurple,
          child: Image.asset(
            'assets/images/mockup_doctor.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  Widget getDoctorSpecialization() {
    return Column(
      children: [
        Text(
          "Orthodontics and dentofacial orthopedics specialist",
          style: TextStyle(color: ColorsHelper.mainDark, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Text(
          "General dentistry",
          style: TextStyle(
            color: ColorsHelper.mainDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget getSpecialistTags() {
    // TODO: replace mockup specialties
    final List<String> specialties = [
      "Orthodontics",
      "Dento-alveolar surgery",
      "Prosthetics",
      "Prosthetics",
      "Prosthetics",
      "Prosthetics",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.specialist, style: StylesHelper.titleStyle),
        SizedBox(height: 15),
        Wrap(
          spacing: 10, // horizontal space between tags
          runSpacing: 10, // vertical space between lines
          children:
              specialties.map((specialty) {
                return InfoTag(infoText: specialty);
              }).toList(),
        ),
      ],
    );
  }

  Widget getReviewsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(StringsHelper.reviews, style: StylesHelper.titleStyle),
        Spacer(),
        Icon(Icons.star, color: ColorsHelper.mainYellow, size: 30),
        Text(
          "4.8/5 (31)",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget getPrices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(StringsHelper.prices, style: StylesHelper.titleStyle)],
    );
  }
}
