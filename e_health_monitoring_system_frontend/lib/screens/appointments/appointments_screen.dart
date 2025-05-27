import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/image_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/models/specialization_dto.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/doctor_profile_screen.dart';
import 'package:e_health_monitoring_system_frontend/widgets/book_now_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_searchbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_category.dart';
import 'package:e_health_monitoring_system_frontend/models/doctor_profile.dart';
import 'package:e_health_monitoring_system_frontend/services/doctor_service.dart';
import 'package:e_health_monitoring_system_frontend/services/specialization_service.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = StringsHelper.allCategories;
  String _selectedCategoryId = "";
  late Future<List<DoctorProfile>> _doctorsFuture;
  List<SpecializationDto> _specializations = [];
  bool _isLoadingSpecializations = true;
  List<DoctorProfile> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    _doctorsFuture = DoctorService.getAllDoctors();
    _fetchSpecializations();
    _searchController.addListener(() {
      _onSearchTextChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(() {
      _onSearchTextChanged(_searchController.text);
    });
    _searchController.dispose();
  }

  void _onSearchTextChanged(String text) async {
    _searchQuery = text;
    final doctors = await _doctorsFuture;
    setState(() {
      filteredDoctors =
          doctors
              .where(
                (item) => item.name.toLowerCase().contains(text.toLowerCase()),
              )
              .toList();
    });
  }

  void _fetchSpecializations() async {
    try {
      final specializations =
          await SpecializationService.getAllSpecializations();
      setState(() {
        _specializations = specializations;
        _isLoadingSpecializations = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSpecializations = false;
      });
      // Handle error
      print('Error fetching specializations: $e');
    }
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
    if (_isLoadingSpecializations) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Text(StringsHelper.categories, style: StylesHelper.titleStyle),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = StringsHelper.allCategories;
                      _doctorsFuture = DoctorService.getAllDoctors();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: MedicalCategory(
                      categoryName: StringsHelper.allCategories,
                      isActive:
                          _selectedCategory == StringsHelper.allCategories,
                      icon: Icons.filter_list,
                    ),
                  ),
                ),
                ..._specializations.map((category) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category.name;

                        if (_selectedCategory == StringsHelper.allCategories) {
                          _doctorsFuture = DoctorService.getAllDoctors();
                        } else {
                          _selectedCategoryId = category.id;

                          _doctorsFuture =
                              DoctorService.getDoctorsBySpecialization(
                                _selectedCategoryId,
                              );
                        }
                      });
                    },

                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: MedicalCategory(
                        categoryName: category.name,
                        isActive: _selectedCategory == category.name,
                      ),
                    ),
                  );
                }),
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
          Text(StringsHelper.popularDoctors, style: StylesHelper.titleStyle),
          const SizedBox(height: 20),
          CustomSearchbar(
            onChanged: _onSearchTextChanged,
            searchController: _searchController,
            searchPlaceholder: StringsHelper.doctorSearchPlaceholder,
          ),
          const SizedBox(height: 20),
          _searchQuery.isNotEmpty
              ? Column(
                children:
                    filteredDoctors.map((doc) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: DoctorCard(
                          doctorName: doc.name,
                          doctorSpecialization:
                              doc.specializations.isNotEmpty
                                  ? doc.specializations
                                  : ["N/A"],
                          detailsList: [
                            BookNowButton(
                              onPressed: () {
                                // Implement booking logic
                              },
                            ),
                          ],
                          doctorPhotoPath: ImageHelper.fixImageUrl(doc.picture),
                          onPressed:
                              () => navigator.push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DoctorProfileScreen(doctor: doc),
                                ),
                              ),
                        ),
                      );
                    }).toList(),
              )
              : FutureBuilder<List<DoctorProfile>>(
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
                                      ? doc.specializations
                                      : ["N/A"],
                              detailsList: [
                                BookNowButton(
                                  onPressed: () {
                                    // Implement booking logic
                                  },
                                ),
                              ],
                              doctorPhotoPath: ImageHelper.fixImageUrl(
                                doc.picture,
                              ),
                              onPressed:
                                  () => navigator.push(
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              DoctorProfileScreen(doctor: doc),
                                    ),
                                  ),
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
