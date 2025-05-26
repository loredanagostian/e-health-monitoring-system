import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/book_now_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_searchbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_category.dart';
import 'package:e_health_monitoring_system_frontend/models/doctor_profile.dart';
import 'package:e_health_monitoring_system_frontend/services/doctor_service.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = StringsHelper.cardiology;
  late Future<List<DoctorProfile>> _doctorsFuture;

  @override
  void initState() {
    super.initState();
    _doctorsFuture = DoctorService().getAllDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCategories(),
                SizedBox(height: 30),
                getPopularDoctors(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategories() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(StringsHelper.categories, style: StylesHelper.titleStyle),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = StringsHelper.cardiology;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: MedicalCategory(
                      categoryName: StringsHelper.cardiology,
                      isActive: _selectedCategory == StringsHelper.cardiology,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = StringsHelper.neurology;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: MedicalCategory(
                      categoryName: StringsHelper.neurology,
                      isActive: _selectedCategory == StringsHelper.neurology,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = StringsHelper.dermatology;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: MedicalCategory(
                      categoryName: StringsHelper.dermatology,
                      isActive: _selectedCategory == StringsHelper.dermatology,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = StringsHelper.dentistry;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: MedicalCategory(
                      categoryName: StringsHelper.dentistry,
                      isActive: _selectedCategory == StringsHelper.dentistry,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getPopularDoctors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Popular Doctors", style: StylesHelper.titleStyle),
          const SizedBox(height: 20),
          CustomSearchbar(
            onChanged: (value) {
              // implement filtering logic
            },
            searchController: _searchController,
            searchPlaceholder: StringsHelper.doctorSearchPlaceholder,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<DoctorProfile>>(
            future: _doctorsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Failed to load doctors: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text("No doctors found.");
              }

              final doctors = snapshot.data!;
              return Column(
                children:
                    doctors.map((doc) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: DoctorCard(
                          doctorName: doc.name,
                          doctorSpecialization:
                              doc.specializations.isNotEmpty
                                  ? doc.specializations[0]
                                  : "N/A",
                          detailsList: [
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: ColorsHelper.mainYellow,
                                  size: 24,
                                ),
                                Text(
                                  "4.8", // Replace with real rating if available
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            BookNowButton(
                              onPressed: () {
                                // Implement booking logic
                              },
                            ),
                          ],
                          doctorPhotoPath: ImageHelper.fixImageUrl(doc.picture),
                        ),
                      );
                    }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
