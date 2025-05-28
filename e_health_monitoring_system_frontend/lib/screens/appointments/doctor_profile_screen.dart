import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/api_models/doctor_profile.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/book_appointment_time_slot.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/info_tag.dart';
import 'package:e_health_monitoring_system_frontend/widgets/price_tile.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatelessWidget {
  final DoctorProfile doctor;
  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appBarTitle: doctor.name, implyLeading: true),
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
                getPrices(),
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
            text: StringsHelper.bookAppointment,
            icon: Icons.arrow_forward_ios,
            onPressed:
                () => navigator.push(
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            BookAppointmentTimeSlotScreen(doctor: doctor),
                  ),
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
          color: ColorsHelper.mainWhite,
          child: Image.network(
            ImageHelper.fixImageUrl(doctor.picture),
            fit: BoxFit.fitHeight,
            errorBuilder:
                (context, error, stackTrace) => Image.asset(
                  'assets/images/mockup_doctor.png',
                  fit: BoxFit.cover,
                ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  Widget getDoctorSpecialization() {
    return Text(
      doctor.description,
      style: TextStyle(
        color: ColorsHelper.mainDark,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget getSpecialistTags() {
    final List<String> specialties = doctor.specializations;

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

  Widget getPrices() {
    final appointments = doctor.appointments;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(StringsHelper.prices, style: StylesHelper.titleStyle),
        SizedBox(height: 15),
        ...appointments.map((appointment) {
          return PriceTile(
            consultationType: appointment.name,
            price: "${appointment.price} LEI",
          );
        }),
      ],
    );
  }
}
