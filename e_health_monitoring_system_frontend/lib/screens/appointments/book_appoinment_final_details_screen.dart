import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_health_monitoring_system_frontend/helpers/colors_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/global_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/strings_helper.dart';
import 'package:e_health_monitoring_system_frontend/helpers/styles_helper.dart';
import 'package:e_health_monitoring_system_frontend/screens/appointments/book_appointment_summary_screen.dart';
import 'package:e_health_monitoring_system_frontend/widgets/booking_dialog.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_appbar.dart';
import 'package:e_health_monitoring_system_frontend/widgets/custom_button.dart';
import 'package:e_health_monitoring_system_frontend/widgets/doctor_card.dart';
import 'package:flutter/material.dart';

class BookAppointmentFinalDetailsScreen extends StatefulWidget {
  final String doctorName;
  final String date;
  final String time;
  const BookAppointmentFinalDetailsScreen({
    super.key,
    required this.doctorName,
    required this.date,
    required this.time,
  });

  @override
  State<BookAppointmentFinalDetailsScreen> createState() =>
      _BookAppointmentFinalDetailsScreenState();
}

class _BookAppointmentFinalDetailsScreenState
    extends State<BookAppointmentFinalDetailsScreen> {
  String? selectedReason;
  String? selectedPrice;

  void onSelectedReasonChange(String reason) {
    final selectedReasonData = reasons.firstWhere(
      (r) => r['label'] == reason,
      orElse: () => <String, dynamic>{},
    );

    setState(() {
      selectedReason = reason;
      selectedPrice =
          selectedReasonData.containsKey('price')
              ? selectedReasonData['price'].toString()
              : null;
    });
  }

  void clearSelection() {
    setState(() {
      selectedReason = null;
      selectedPrice = null;
    });
  }

  final List<Map<String, dynamic>> reasons = [
    {'label': 'Prosthetic Consultation', 'price': "220 LEI"},
    {'label': 'Prosthetic Check-up', 'price': "85 LEI"},
    {'label': 'Acrylic Temporary Crown in Office', 'price': "120 LEI"},
    {'label': 'Acrylic Temporary Crown in Laboratory', 'price': "290 LEI"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appBarTitle: StringsHelper.bookAppointment,
        implyLeading: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DoctorCard(
                  doctorName: widget.doctorName,
                  doctorSpecialization: [], // TODO
                  detailsList: [
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 20,
                              color: ColorsHelper.mainPurple,
                            ),
                            SizedBox(width: 5),
                            Text(
                              widget.date,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 20,
                              color: ColorsHelper.mainPurple,
                            ),
                            SizedBox(width: 5),
                            Text(
                              widget.time,
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
                  doctorPhotoPath: "assets/images/mockup_doctor.png",
                ),
                SizedBox(height: 30),
                getReasonToVisit(),
                SizedBox(height: 30),
                getTotalCost(),
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
            text: StringsHelper.bookNow,
            icon: Icons.arrow_forward_ios,
            backgroundColor:
                selectedReason == null
                    ? ColorsHelper.mediumGray
                    : ColorsHelper.mainPurple,
            onPressed:
                selectedReason != null
                    ? () => showAppointmentBookedDialog(
                      context,
                      () => navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder:
                              (context) => BookAppointmentSummaryScreen(
                                doctorName: widget.doctorName,
                                date: widget.date,
                                time: widget.time,
                                totalCost: selectedPrice!,
                                reasonToVisit: selectedReason!,
                                isSuccess: false,
                              ),
                        ),
                        (route) => false,
                      ),
                    )
                    : null, // disable button when no reason selected
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
        DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: const Row(
              children: [
                Expanded(
                  child: Text(
                    StringsHelper.searchReasonToVisit,
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorsHelper.mediumGray,
                      fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items:
                reasons
                    .map(
                      (reason) => DropdownMenuItem<String>(
                        value: reason['label'], // value is the label string
                        child: Text(
                          reason['label'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorsHelper.darkGray,
                            fontWeight: FontWeight.normal,
                          ),
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    )
                    .toList(),
            value: selectedReason,
            onChanged: (value) => onSelectedReasonChange(value ?? ""),
            buttonStyleData: ButtonStyleData(
              height: 55,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: ColorsHelper.mediumGray),
                color: ColorsHelper.lightGray,
              ),
            ),
            iconStyleData: IconStyleData(
              icon: IconButton(
                icon: Icon(
                  selectedReason != null
                      ? Icons.close
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: selectedReason != null ? clearSelection : null,
              ),
              iconSize: selectedReason != null ? 20 : 28,
              iconEnabledColor: ColorsHelper.darkGray,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: ColorsHelper.lightGray,
              ),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: WidgetStateProperty.all(4),
                thumbVisibility: WidgetStateProperty.all(true),
                thumbColor: WidgetStateProperty.all(ColorsHelper.mediumGray),
                crossAxisMargin: 5,
                mainAxisMargin: 5,
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget getTotalCost() {
    return selectedPrice != null && selectedReason != null
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(StringsHelper.totalCost, style: StylesHelper.titleStyle),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    selectedReason ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsHelper.darkGray,
                    ),
                  ),
                ),
                Text(
                  selectedPrice ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsHelper.darkGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "Platform fee",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsHelper.darkGray,
                    ),
                  ),
                ),
                Text(
                  "10 LEI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsHelper.darkGray,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: ColorsHelper.darkGray, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsHelper.mainDark,
                    ),
                  ),
                ),
                Text(
                  "XX LEI",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorsHelper.mainDark,
                  ),
                ),
              ],
            ),
          ],
        )
        : Container();
  }
}
