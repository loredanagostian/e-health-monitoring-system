import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String doctorName;
  final List<String> doctorSpecialization;
  final String doctorPhotoPath;
  final List<Widget> detailsList;
  final double? width;
  final bool hasVisibleIcons;
  final Function()? onPressed;
  const DoctorCard({
    super.key,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.detailsList,
    required this.doctorPhotoPath,
    this.width,
    this.hasVisibleIcons = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: ColorsHelper.lightGray,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorsHelper.mediumGray),
        ),
        child: Stack(
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      child: Image.network(
                        doctorPhotoPath,
                        fit: BoxFit.cover,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 10,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctorName,
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorsHelper.mainDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                doctorSpecialization
                                    .expand((spec) => spec.split('|'))
                                    .map(
                                      (spec) => Text(
                                        spec.trim(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: ColorsHelper.darkGray,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                          Spacer(),
                          ...detailsList,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: hasVisibleIcons,
              child: Positioned(
                bottom: 15,
                right: 15,
                child: GestureDetector(
                  // TODO: navigate to Appointment Details
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: ColorsHelper.mainDark,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
