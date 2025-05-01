import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/widgets/book_now_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_searchbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:e_health_monitoring_system_frontend/widgets/medical_category.dart';
import 'package:e_health_monitoring_system_frontend/widgets/view_all_button.dart';
import 'package:flutter/material.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = StringsHelper.cardiology;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(StringsHelper.categories, style: StylesHelper.titleStyle),
              ViewAllButton(onPressed: () {}),
            ],
          ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringsHelper.popularDoctors, style: StylesHelper.titleStyle),
          SizedBox(height: 20),
          CustomSearchbar(
            onChanged: (String) {},
            searchController: _searchController,
            searchPlaceholder: StringsHelper.doctorSearchPlaceholder,
          ),
          SizedBox(height: 20),
          DoctorCard(
            doctorName: "Dr. Lorem Ipsum",
            doctorSpecialization: _selectedCategory,
            detailsList: [
              Row(
                children: [
                  Icon(Icons.star, color: ColorsHelper.mainYellow, size: 24),
                  Text(
                    "4.8",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              BookNowButton(onPressed: () {}),
            ],
            doctorPhotoPath: 'assets/images/mockup_doctor.png',
          ),
          SizedBox(height: 20),
          DoctorCard(
            doctorName: "Dr. Lorem Ipsum",
            doctorSpecialization: _selectedCategory,
            detailsList: [
              Row(
                children: [
                  Icon(Icons.star, color: ColorsHelper.mainYellow, size: 24),
                  Text(
                    "4.8",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              BookNowButton(onPressed: () {}),
            ],
            doctorPhotoPath: 'assets/images/mockup_doctor.png',
          ),
          SizedBox(height: 20),
          DoctorCard(
            doctorName: "Dr. Lorem Ipsum",
            doctorSpecialization: _selectedCategory,
            detailsList: [
              Row(
                children: [
                  Icon(Icons.star, color: ColorsHelper.mainYellow, size: 24),
                  Text(
                    "4.8",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 10),
              BookNowButton(onPressed: () {}),
            ],
            doctorPhotoPath: 'assets/images/mockup_doctor.png',
          ),
        ],
      ),
    );
  }
}
